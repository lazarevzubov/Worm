//
//  SearchModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 20.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation
import GoodreadsService

/// The search screen model.
protocol SearchModel: ObservableObject {

    // MARK: - Properties

    /// The list of books corresponding to the current search query.
    var books: [Book] { get }
    /// The list of favorite book IDs.
    var favoriteBookIDs: [String] { get }

    // MARK: - Methods

    /// Queries the book search engine.
    /// - Parameter query: The query to search.
    func searchBooks(by query: String)
    /// Toggles the favorite-ness state of a book.
    /// - Parameter id: The ID of the book to manipulate.
    func toggleFavoriteStateOfBook(withID id: String)

}

// MARK: -

/// The search screen model implemented on top of a data providing service.
final class SearchServiceBasedModel<RecommendationsService: FavoritesService>: SearchModel {

    // MARK: - Properties

    // MARK: SearchModel protocol properties

    @Published
    private(set) var books = [Book]()
    @Published
    private(set) var favoriteBookIDs = [String]()

    // MARK: Private properties

    private let catalogService: CatalogService
    private let favoritesService: RecommendationsService
    private let queryDelay: Duration?
    private var currentSearchResult = [String]() {
        didSet {
            currentSearchResult.forEach { result in
                Task { await handleSearchResult(result) }
            }
        }
    }
    private var currentSearchTask: Task<(), Never>?

    // MARK: - Initialization

    /// Creates a model.
    /// - Parameters:
    ///   - catalogService: The data providing service.
    ///   - favoritesService: A service providing an interface to track and manipulate the list of favorite books.
    ///   - queryDelay: The delay after which the request is actually dispatched. This delay is useful to prevent too many request while typing a query.
    init(catalogService: CatalogService,
         favoritesService: RecommendationsService,
         queryDelay: Duration? = .milliseconds(500)) {
        self.catalogService = catalogService
        self.favoritesService = favoritesService
        self.queryDelay = queryDelay

        updateFavorites()
    }

    // MARK: - Methods

    // MARK: SearchModel protocol methods

    func searchBooks(by query: String) {
        currentSearchTask?.cancel()

        let newSearchTask = Task {
            books.removeAll()
            currentSearchResult.removeAll()

            if !query.isEmpty {
                self.currentSearchResult = await self.catalogService.searchBooks(query)
            }
        }
        currentSearchTask = newSearchTask

        Task {
            if let queryDelay {
                try? await Task.sleep(for: queryDelay)
            }
            await newSearchTask.value
        }
    }

    func toggleFavoriteStateOfBook(withID id: String) {
        if favoriteBookIDs.contains(id) {
            favoritesService.removeFromFavoriteBook(withID: id)
        } else {
            favoritesService.addToFavoritesBook(withID: id)
        }
        updateFavorites()
    }

    // MARK: Private methods

    private func updateFavorites() {
        favoriteBookIDs = favoritesService.favoriteBookIDs
    }

    private func handleSearchResult(_ result: String) async {
        if let book = await catalogService.getBook(by: result) {
            await MainActor.run { appendIfNeeded(book: book) }
        }
    }

    private func appendIfNeeded(book: Book) {
        if currentSearchResult.contains(book.id) {
            books.append(book)
        }
    }

}
