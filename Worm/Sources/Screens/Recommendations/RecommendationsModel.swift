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

    /**
     Toggles the favorite-ness state of a book.
     - Parameter bookID: The ID of the book to manipulate.
     */
    func toggleFavoriteState(bookID: String)
    /**
     Blocks a book ID from appearing as a recommendation.
     - Parameter bookID: The ID of the book to manipulate.
     */
    func blockFromRecommendations(bookID: String)

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

    private let catalogueService: CatalogueService
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

    /**
     Creates a recommended books list handler.
     - Parameters:
        - catalogueService: The data service of the app.
        - favoritesService: The favorite books list manager.
     */
    init(catalogueService: CatalogueService, favoritesService: RecommendationsService) {
        self.catalogueService = catalogueService
        self.favoritesService = favoritesService

        bind(favoritesService: self.favoritesService)
        updateFavorites()
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    func toggleFavoriteState(bookID: String) {
        if favoriteBookIDs.contains(bookID) {
            favoritesService.removeFromFavoriteBooks(bookID)
        } else {
            favoritesService.addToFavoriteBooks(bookID)
        }
        updateFavorites()
    }

    func blockFromRecommendations(bookID: String) {
        prioritizedRecommendations[bookID] = nil
        favoritesService.addToBlockedBooks(bookID)
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
            Task { await addSimilarBooksToRecommendations(from: id) }
        }
    }

    private func addSimilarBooksToRecommendations(from bookID: String) async {
        let book = await catalogueService.getBook(by: bookID)
        addSimilarBooksToRecommendations(from: book?.similarBookIDs ?? [])
    }

    private func addSimilarBooksToRecommendations(from ids: [String]) {
        let blockedBooks = favoritesService.blockedBooks
        let filteredIDs = ids.filter { id in
            !blockedBooks.contains { $0.id == id } // Filter out blocked books from recommendations.
        }
        filteredIDs.forEach { id in
            Task { await addRecommendation(id: id) }
        }
    }

    private func addRecommendation(id: String) async {
        if let bookDescriptor = prioritizedRecommendations[id] {
            prioritizedRecommendations[id] = (bookDescriptor.priority + 1, bookDescriptor.book)
        } else {
            prioritizedRecommendations[id] = (1, nil)

            let book = await catalogueService.getBook(by: id)
            if let bookDescriptor = prioritizedRecommendations[id], 
               bookDescriptor.book == nil {
                prioritizedRecommendations[id] = (bookDescriptor.priority, book)
            }
        }
    }

}
