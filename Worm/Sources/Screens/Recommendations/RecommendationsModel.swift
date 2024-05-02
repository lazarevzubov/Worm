//
//  RecommendationsModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Dispatch
import GoodreadsService
import OrderedCollections

/// Owns logic of maintaining a list of recommendations.
protocol RecommendationsModel: Sendable {

    // FIXME: Duplication with SearchModel?
    // TODO: Unblock?

    // MARK: - Properties

    /// The list of favorite book IDs.
    var favoriteBookIDs: Set<String> { get }
    // TODO: HeaderDoc.
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { get }
    /// A list of recommended books in ready-to-display order.
    var recommendations: Set<Book> { get }
    // TODO: HeaderDoc.
    var recommendationsPublisher: Published<Set<Book>>.Publisher { get }

    // MARK: - Methods

    /// Toggles the favorite-ness state of a book.
    /// - Parameter id: The ID of the book to manipulate.
    func toggleFavoriteStateOfBook(withID id: String) async
    /// Blocks a book ID from appearing as a recommendation.
    /// - Parameter bookID: The ID of the book to manipulate.
    func blockFromRecommendationsBook(withID id: String)

}

// MARK: -

/// The default logic of the recommendations list maintenance.
final class RecommendationsDefaultModel<RecommendationsService: FavoritesService>: @unchecked Sendable,
                                                                                   RecommendationsModel {

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
    private let favoriteBookIDsSynchronizationQueue = DispatchQueue(label: "com.lazarevzubov.FavoriteBookIDs")
    private let favoritesService: RecommendationsService
    private let recommendationsSynchronizationQueue = DispatchQueue(label: "com.lazarevzubov.Recommendations")
    private lazy var cancellables = Set<AnyCancellable>()
    private var prioritizedRecommendations = OrderedDictionary<String, (book: Book, sourceIDs: Set<String>)>() {
        didSet {
            recommendationsSynchronizationQueue.sync {
                recommendations = Set(
                    prioritizedRecommendations
                        .values
                        .stableSorted { $0.sourceIDs.count > $1.sourceIDs.count }
                        .compactMap { $0.book }
                )
            }
        }
    }

    // MARK: - Initialization

    /// Creates a recommended books list handler.
    /// - Parameters:
    ///   - catalogService: The data service of the app.
    ///   - favoritesService: The favorite books list manager.
    init(catalogService: CatalogService, favoritesService: RecommendationsService) {
        self.catalogService = catalogService
        self.favoritesService = favoritesService

        bind(favoritesService: favoritesService)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) async {
        if favoriteBookIDs.contains(id) {
            favoritesService.removeFromFavoriteBook(withID: id)
            removeRecommendedBooksForBook(withID: id)
        } else {
            favoritesService.addToFavoritesBook(withID: id)
            await addRecommendedBooksForBook(withID: id)
        }
    }

    func blockFromRecommendationsBook(withID id: String) {
        prioritizedRecommendations.removeValue(forKey: id)
        favoritesService.addToBlockedBook(withID: id)
    }

    // MARK: Private methods

    private func bind(favoritesService: RecommendationsService) {
        favoritesService
            .favoriteBookIDsPublisher
            .sink { id in
                Task { [weak self] in
                    await self?.update(with: id)
                }
            }
            .store(in: &cancellables)
    }

    private func update(with favoriteBookIDs: Set<String>) async {
        favoriteBookIDsSynchronizationQueue.sync { self.favoriteBookIDs = favoriteBookIDs }
        await addRecommendedBooksForBooks(withIDs: favoriteBookIDs)
    }

    private func addRecommendedBooksForBooks(withIDs ids: Set<String>) async {
        for id in ids {
            await addRecommendedBooksForBook(withID: id)
        }
    }

    private func addRecommendedBooksForBook(withID id: String) async {
        let book = await catalogService.getBook(by: id)
        await addRecommendedBooks(withIDs: book?.similarBookIDs ?? [], for: id)
    }

    private func addRecommendedBooks(withIDs ids: [String], for sourceID: String) async {
        let blockedBooks = favoritesService.blockedBookIDs
        let filteredIDs = ids.filter { id in
            !blockedBooks.contains(id)
        }

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
        if favoritesService.blockedBookIDs.contains(id) {
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
