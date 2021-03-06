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

    /**
     Queries the book search engine.
     - Parameter query: The query to search.
     */
    func searchBooks(by query: String)
    /**
     Toggles the favorite-ness state of a book.
     - Parameter bookID: The ID of the book to manipulate.
     */
    func toggleFavoriteState(bookID: String)

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

    private let catalogueService: CatalogueService
    private let dispatchQueue: DispatchQueue
    private let favoritesService: RecommendationsService
    private let queryDelay: DispatchTimeInterval?
    private var currentSearchResult = [String]() {
        didSet { currentSearchResult.forEach { handleSearchResult($0) } }
    }
    private var currentSearchWorkItem: DispatchWorkItem?

    // MARK: - Initialization

    /**
     Creates a model.

     - Parameters:
        - catalogueService: The data providing service.
        - favoritesService: A service providing an interface to track and manipulate the list of favorite books.
        - dispatchQueue: The queue to dispatch search requests.
        - queryDelay: The delay after which the request is actually dispatched. This delay is useful to prevent too many request while typing a query.
     */
    init(catalogueService: CatalogueService,
         favoritesService: RecommendationsService,
         dispatchQueue: DispatchQueue = DispatchQueue(label: "com.LazarevZubov.Worm.SearchDefaultModel"),
         queryDelay: DispatchTimeInterval? = .milliseconds(500)) {
        self.catalogueService = catalogueService
        self.favoritesService = favoritesService
        self.dispatchQueue = dispatchQueue
        self.queryDelay = queryDelay

        updateFavorites()
    }

    // MARK: - Methods

    // MARK: SearchModel protocol methods

    func searchBooks(by query: String) {
        currentSearchWorkItem?.cancel()

        let newSearchWorkItem = makeSearchWorkItem(query: query)
        currentSearchWorkItem = newSearchWorkItem

        if let queryDelay = queryDelay {
            dispatchQueue.asyncAfter(deadline: .now() + queryDelay, execute: newSearchWorkItem)
        } else {
            dispatchQueue.async(execute: newSearchWorkItem)
        }
    }

    func toggleFavoriteState(bookID: String) {
        if favoriteBookIDs.contains(bookID) {
            favoritesService.removeFromFavoriteBooks(bookID)
        } else {
            favoritesService.addToFavoriteBooks(bookID)
        }
        updateFavorites()
    }

    // MARK: Private methods

    private func updateFavorites() {
        favoriteBookIDs = favoritesService.favoriteBooks.compactMap { $0.id }
    }

    private func makeSearchWorkItem(query: String) -> DispatchWorkItem {
        return DispatchWorkItem { [weak self] in
            self?.reset()
            if !query.isEmpty {
                self?.handle(searchQuery: query)
            }
        }
    }

    private func reset() {
        books.removeAll()
        currentSearchResult.removeAll()
    }

    private func handle(searchQuery: String) {
        catalogueService.searchBooks(searchQuery) { [weak self] in
            self?.currentSearchResult = $0
        }
    }

    private func handleSearchResult(_ result: String) {
        catalogueService.getBook(by: result) { [weak self] book in
            guard let book = book else {
                return
            }
            self?.appendIfNeeded(book: book)
        }
    }

    private func appendIfNeeded(book: Book) {
        if currentSearchResult.contains(book.id) {
            books.append(book)
        }
    }

}
