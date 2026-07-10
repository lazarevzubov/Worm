//
//  Service.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 23.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

/// The data service of the app.
protocol CatalogService: Sendable {

    // MARK: - Methods

    /// Dispatches a book search query.
    /// - Parameter query: The search query.
    /// - Returns: The result of the query consisting of book IDs.
    func searchBooks(_ query: String) async -> [String]
    /// Dispatches a request of a book info.
    /// - Parameter id: The ID of the book.
    /// - Returns: The result of the request.
    func getBook(by id: String) async -> Book?

}

// MARK: -

/// The data service of the app, based on the Goodreads service.
///
/// The book-retrieving APIs take advantage from a caching layer to provide repeatedly requested data in more efficient way.
final class CatalogGoodreadsService: CatalogService {

    // MARK: - Properties

    // MARK: Private properties

    private let cacheService: any CacheService<String, Book>
    private let goodreadsService: GoodreadsService

    // MARK: - Initialization

    /// Creates a data service of the app, based on the Goodreads service.
    /// - Parameters:
    ///   - goodreadsService: The entry point to the service.
    ///   - cacheService: Stores results of computations or distributed calls to provide them in a more efficient manner than repeating the initial call again.
    init(goodreadsService: GoodreadsService, cacheService: any CacheService<String, Book>) {
        self.goodreadsService = goodreadsService
        self.cacheService = cacheService
    }

    // MARK: - Methods

    // MARK: CatalogService protocol methods

    func searchBooks(_ query: String) async -> [String] {
        await goodreadsService.searchBooks(query)
    }

    func getBook(by id: String) async -> Book? {
        if let book = await cacheService.storage[id] {
            return book
        }

        let book = await goodreadsService.getBook(by: id)
        if let book {
            await cacheService.insert(book, for: id)
        }

        return book
    }


}

#if DEBUG

// MARK: -

final class CatalogPreviewsService: CatalogService {

    // MARK: - Methods

    // MARK: Service protocol methods

    func searchBooks(_ query: String) async -> [String] {
        Book.previewFixtures.map { $0.id }
    }

    func getBook(by id: String) async -> Book? {
        Book.previewFixtures.first { $0.id == id }
    }

}

#endif
