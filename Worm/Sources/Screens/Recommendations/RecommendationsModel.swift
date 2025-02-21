//
//  RecommendationsModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService
import OrderedCollections

/// Owns logic of maintaining a list of recommendations.
protocol RecommendationsModel: Actor {

    // TODO: Unblock?

    // MARK: - Properties

    /// The list of favorite book IDs.
    var favoriteBookIDs: Set<String> { get }
    /// The publisher of changes to the list of favorite book IDs.
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { get }
    /// A list of recommended books in ready-to-display order.
    var recommendations: Set<Book> { get }
    /// The publisher of changes to the list of recommended books.
    var recommendationsPublisher: Published<Set<Book>>.Publisher { get }

    // MARK: - Methods

    /// Toggles the favorite-ness state of a book.
    /// - Parameter id: The ID of the book to manipulate.
    func toggleFavoriteStateOfBook(withID id: String) async
    /// Blocks a book ID from appearing as a recommendation.
    /// - Parameter bookID: The ID of the book to manipulate.
    func blockFromRecommendationsBook(withID id: String) async

}

// MARK: -

/// The default logic of the recommendations list maintenance.
actor RecommendationsDefaultModel: RecommendationsModel {

    // MARK: - Properties

    // MARK: RecommendationsModel protocol properties

    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { $favoriteBookIDs }
    var recommendationsPublisher: Published<Set<Book>>.Publisher { $recommendations }
    @Published
    private(set) var favoriteBookIDs = Set<String>()
    @Published
    private(set) var recommendations = Set<Book>()

    // MARK: Private properties

    private let catalogService: CatalogService
    private let favoritesService: any FavoritesService
    private lazy var cancellables = Set<AnyCancellable>()
    private var prioritizedRecommendations = OrderedDictionary<String, (book: Book, sourceIDs: Set<String>)>() {
        didSet {
            recommendations = Set(
                prioritizedRecommendations
                    .values
                    .stableSorted { $0.sourceIDs.count > $1.sourceIDs.count }
                    .compactMap { $0.book }
            )
        }
    }

    // MARK: - Initialization

    /// Creates a recommended books list handler.
    /// - Parameters:
    ///   - catalogService: The data service of the app.
    ///   - favoritesService: The favorite books list manager.
    init(catalogService: CatalogService, favoritesService: any FavoritesService) {
        self.catalogService = catalogService
        self.favoritesService = favoritesService

        Task { [weak self] in
            await self?.bind(favoritesService: favoritesService)
        }
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) async {
        if favoriteBookIDs.contains(id) {
            await favoritesService.removeFromFavoriteBook(withID: id)
            removeRecommendedBooksForBook(withID: id)
        } else {
            await favoritesService.addToFavoritesBook(withID: id)
            await addRecommendedBooksForBook(withID: id)
        }
    }

    func blockFromRecommendationsBook(withID id: String) async {
        prioritizedRecommendations.removeValue(forKey: id)
        await favoritesService.addToBlockedBook(withID: id)
    }

    // MARK: Private methods

    private func bind(favoritesService: any FavoritesService) async {
        await favoritesService
            .favoriteBookIDsPublisher
            .removeDuplicates()
            .sink { @Sendable ids in
                Task { [weak self] in
                    await self?.update(with: ids)
                }
            }
            .store(in: &cancellables)
    }

    private func update(with favoriteBookIDs: Set<String>) async {
        self.favoriteBookIDs = favoriteBookIDs
        await addRecommendedBooksForBooks(withIDs: favoriteBookIDs)
    }

    private func addRecommendedBooksForBooks(withIDs ids: Set<String>) async {
        for id in ids {
            await addRecommendedBooksForBook(withID: id)
        }
    }

    private func addRecommendedBooksForBook(withID id: String) async {
        await addRecommendedBooks(withIDs: catalogService.getBook(by: id)?.similarBookIDs ?? [], for: id)
    }

    private func addRecommendedBooks(withIDs ids: [String], for sourceID: String) async {
        let blockedBookIDs = await favoritesService.blockedBookIDs
        let filteredIDs = ids.filter { !blockedBookIDs.contains($0) }
        for id in filteredIDs {
            await addRecommendedBook(withID: id, for: sourceID)
        }
    }

    private func addRecommendedBook(withID id: String, for sourceID: String) async {
        if let bookDescriptor = prioritizedRecommendations[id] {
            var sourceIDs = bookDescriptor.sourceIDs
            sourceIDs.insert(sourceID)

            prioritizedRecommendations[id] = (bookDescriptor.book, sourceIDs)
        }

        guard let book = await catalogService.getBook(by: id) else {
            return
        }

        // This needs re-checking, because the situation might've changed while the book was being fetched.
        if await favoritesService.blockedBookIDs.contains(id) {
            prioritizedRecommendations.removeValue(forKey: id)
        } else {
            prioritizedRecommendations[id] = (book, [sourceID])
        }
    }

    private func removeRecommendedBooksForBook(withID id: String) {
        for bookDescriptor in prioritizedRecommendations {
            var sourceIDs = bookDescriptor.value.sourceIDs
            guard sourceIDs.contains(id) else {
                continue
            }

            if sourceIDs.count == 1 {
                prioritizedRecommendations.removeValue(forKey: bookDescriptor.key)
            } else {
                sourceIDs.remove(id)
                prioritizedRecommendations[bookDescriptor.key] = (bookDescriptor.value.book, sourceIDs)
            }
        }
    }

}
