//
//  CatalogMockService.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 17.4.2024.
//

import GoodreadsService
@testable
import Worm

final class CatalogMockService: CatalogService {

    // MARK: - Properties

    // MARK: Private properties

    private let books: [Book]
    private let queries: [String : [String]]

    // MARK: - Initialization

    init(books: [Book] = [], queries: [String : [String]] = [:]) {
        self.books = books
        self.queries = queries
    }

    // MARK: - Methods

    // MARK: Service protocol methods

    func searchBooks(_ query: String) async -> [String] {
        queries[query] ?? []
    }

    func getBook(by id: String) async -> Book? {
        books.first { $0.id == id }
    }

}

