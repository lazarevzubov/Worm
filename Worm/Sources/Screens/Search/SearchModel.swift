//
//  SearchModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 20.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

/// The search screen model.
protocol SearchModel: Actor {

    // MARK: - Properties

    /// The list of books corresponding to the current search query.
    var books: Set<Book> { get }
    /// The publisher of changes to the list of books corresponding to the current search query.
    var booksPublisher: Published<Set<Book>>.Publisher { get }
    /// The list of favorite book IDs.
    var favoriteBookIDs: Set<String> { get }
    /// The publisher of books to the list of favorite book IDs.
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { get }

    // MARK: - Methods

    /// Queries the book search engine.
    /// - Parameter query: The query to search.
    func searchBooks(by query: String) async
    /// Toggles the favorite-ness state of a book.
    /// - Parameter id: The ID of the book to manipulate.
    func toggleFavoriteStateOfBook(withID id: String) async

}

// MARK: -

/// The search screen model implemented on top of a data providing service.
actor SearchServiceBasedModel: SearchModel {

    // MARK: - Properties

    // MARK: SearchModel protocol properties

    var booksPublisher: Published<Set<Book>>.Publisher { $books }
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { $favoriteBookIDs }
    @Published
    private(set) var books = Set<Book>()
    @Published
    private(set) var favoriteBookIDs = Set<String>()

    // MARK: Private properties

    private let catalogService: CatalogService
    private let favoritesService: FavoritesService
    private let queryDelay: Duration?
    private lazy var cancellables = Set<AnyCancellable>()
    private var currentSearchResult = [String]() {
        didSet {
            currentSearchResult.forEach { result in
                Task { await handleSearchResult(result) }
            }
        }
    }
    private var currentSearchTask: Task<(), Error>?

    // MARK: - Initialization

    /// Creates a model.
    /// - Parameters:
    ///   - catalogService: The data providing service.
    ///   - favoritesService: A service providing an interface to track and manipulate the list of favorite books.
    ///   - queryDelay: The delay after which the request is actually dispatched. This delay is useful to prevent too many request while typing a query.
    init(
        catalogService: CatalogService, favoritesService: FavoritesService, queryDelay: Duration? = .milliseconds(500)
    ) {
        self.catalogService = catalogService
        self.favoritesService = favoritesService
        self.queryDelay = queryDelay

        Task { [weak self] in
            await self?.bind(favoritesService: favoritesService)
        }
    }

    // MARK: - Methods

    // MARK: SearchModel protocol methods

    func searchBooks(by query: String) async {
        currentSearchTask?.cancel()
        currentSearchTask = Task {
            if let queryDelay {
                try await Task.sleep(for: queryDelay)
            }
            guard !Task.isCancelled else {
                return
            }

            books.removeAll()
            currentSearchResult.removeAll()

            if !query.isEmpty {
                self.currentSearchResult = await self.catalogService.searchBooks(query)
            }
        }
    }

    func toggleFavoriteStateOfBook(withID id: String) async {
        if favoriteBookIDs.contains(id) {
            await favoritesService.removeFromFavoriteBook(withID: id)
        } else {
            await favoritesService.addToFavoritesBook(withID: id)
        }
    }

    // MARK: Private methods

    private func bind(favoritesService: FavoritesService) async {
        await favoritesService
            .favoriteBookIDsPublisher
            .removeDuplicates()
            .sink { @Sendable [weak self] favoriteBookIDs in
                Task { [weak self] in
                    await self?.updateFavoriteBookIDs(favoriteBookIDs)
                }
            }
            .store(in: &cancellables)
    }

    private func updateFavoriteBookIDs(_ favoriteBookIDs: Set<String>) {
        self.favoriteBookIDs = favoriteBookIDs
    }

    private func handleSearchResult(_ result: String) async {
        if let book = await catalogService.getBook(by: result) {
            appendIfNeeded(book: book)
        }
    }

    private func appendIfNeeded(book: Book) {
        if currentSearchResult.contains(book.id) {
            books.insert(book)
        }
    }

}
