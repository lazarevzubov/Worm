//
//  RecommendationsModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

/// Owns logic of maintaining a list of recommendations.
protocol RecommendationsModel: ObservableObject {

    // FIXME: Duplication with SearchModel?
    // TODO: Unblock?

    // MARK: - Properties

    /// The list of favorite book IDs.
    var favoriteBookIDs: [String] { get }
    /// A list of recommended books in ready-to-display order.
    var recommendations: [Book] { get }

    // MARK: - Methods

    /// Toggles the favorite-ness state of a book.
    /// - Parameter id: The ID of the book to manipulate.
    func toggleFavoriteStateOfBook(withID id: String)
    /// Blocks a book ID from appearing as a recommendation.
    /// - Parameter bookID: The ID of the book to manipulate.
    func blockFromRecommendationsBook(withID id: String)

}

// MARK: -

/// The default logic of the recommendations list maintenance.
final class RecommendationsDefaultModel<RecommendationsService: FavoritesService>: RecommendationsModel {

    // MARK: - Properties

    // MARK: RecommendationsModel protocol properties

    @Published
    private(set) var favoriteBookIDs = [String]()
    @Published
    var recommendations = [Book]()

    // MARK: Private properties

    private let catalogService: CatalogService
    private let favoritesService: RecommendationsService
    private lazy var cancellables = Set<AnyCancellable>()
    private var prioritizedRecommendations = [String: (priority: Int, book: Book?)]() {
        didSet {
            recommendations = prioritizedRecommendations
                .map { $0.value }
                .sorted { $0.priority > $1.priority }
                .compactMap { $0.book }
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

        bind(favoritesService: self.favoritesService)
        updateFavorites()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        if favoriteBookIDs.contains(id) {
            favoritesService.removeFromFavoriteBook(withID: id)
        } else {
            favoritesService.addToFavoritesBook(withID: id)
        }
        updateFavorites()
    }

    func blockFromRecommendationsBook(withID id: String) {
        prioritizedRecommendations[id] = nil
        favoritesService.addToBlockedBook(withID: id)
    }

    // MARK: Private methods

    private func bind(favoritesService: RecommendationsService) {
        favoritesService
            .objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.updateFavorites()
            }
            .store(in: &cancellables)
    }

    private func updateFavorites() {
        favoriteBookIDs = favoritesService.favoriteBooks.compactMap { $0.id }
        favoriteBookIDs.forEach { id in
            Task { await addSimilarBooksToRecommendationsFromBook(withID: id) }
        }
    }

    private func addSimilarBooksToRecommendationsFromBook(withID id: String) async {
        let book = await catalogService.getBook(by: id)
        addSimilarToRecommendationsBooks(withIDs: book?.similarBookIDs ?? [])
    }

    private func addSimilarToRecommendationsBooks(withIDs ids: [String]) {
        let blockedBooks = favoritesService.blockedBooks
        let filteredIDs = ids.filter { id in
            !blockedBooks.contains { $0.id == id } // Filter out blocked books from recommendations.
        }
        filteredIDs.forEach { id in
            Task { await addToRecommendationsBook(withID: id) }
        }
    }

    private func addToRecommendationsBook(withID id: String) async {
        if let bookDescriptor = prioritizedRecommendations[id] {
            prioritizedRecommendations[id] = (bookDescriptor.priority + 1, bookDescriptor.book)
        } else {
            prioritizedRecommendations[id] = (1, nil)

            let book = await catalogService.getBook(by: id)
            if let bookDescriptor = prioritizedRecommendations[id],
               bookDescriptor.book == nil {
                prioritizedRecommendations[id] = (bookDescriptor.priority, book)
            }
        }
    }

}
