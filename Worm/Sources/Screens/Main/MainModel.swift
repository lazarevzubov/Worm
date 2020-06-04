//
//  MainModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 20.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
import Foundation
import GoodreadsService

/// The search screen model.
protocol MainModel: ObservableObject {

    // MARK: - Properties

    /// The list of books corresponding to the current search query.
    var books: [Book] { get }

    // MARK: - Methods

    /**
     Queries the book search engine.
     - Parameter query: The query to search.
     */
    func searchBooks(by query: String)
    // TODO: HeaderDoc.
    func isFavorite(id: String) -> Bool

}

// MARK: -

/// The search screen model implemented on top of a data providing service.
final class MainDefaultModel: MainModel {

    // MARK: - Properties

    // MARK: MainModel protocol properties

    @Published
    private(set) var books = [Book]()

    // MARK: Private properties

    private let catalogueService: CatalogueService
    private let dispatchQueue: DispatchQueue
    private let persistenseService: PersistenseService
    private let queryDelay: DispatchTimeInterval?
    private var currentSearchResult = [String]() {
        didSet { currentSearchResult.forEach { handleSearchResult($0) } }
    }
    private var currentSearchWorkItem: DispatchWorkItem?

    // MARK: - Initialization

    // TODO: Update HeaderDoc.
    /**
     Creates a model.

     - Parameters:
        - service: The data providing service.
        - dispatchQueue: The queue to dispatch search requests.
        - queryDelay: The delay after which the request is actually dispatched. This delay is useful to prevent too many request while typing a query.
     */
    init(catalogueService: CatalogueService,
         persistenseService: PersistenseService,
         dispatchQueue: DispatchQueue = DispatchQueue(label: "com.LazarevZubov.Worm.MainDefaultModel"),
         queryDelay: DispatchTimeInterval? = .milliseconds(500)) {
        self.catalogueService = catalogueService
        self.persistenseService = persistenseService
        self.dispatchQueue = dispatchQueue
        self.queryDelay = queryDelay
    }

    // MARK: - Methods

    // MARK: MainModel protocol methods

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

    func isFavorite(id: String) -> Bool {
        return persistenseService.favoriteBooks.map { $0.id }.contains(id)
    }

    // MARK: Private methods

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
        // TODO: Find a way to test it.
        if currentSearchResult.contains(book.id) {
            books.append(book)
        }
    }

}
