//
//  CatalogueTestingMockService.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 18.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class CatalogueTestingMockService: CatalogueService {

    // MARK: - Properties

    let books: [Book]
    let searchBookResult: [String]
    private(set) var handledBookRequests = [String]()
    private(set) var handledQueries = [String]()

    // MARK: Private properties

    private let bookRequestExpectation: XCTestExpectation?
    private var searchExpectation: XCTestExpectation?

    // MARK: - Initialization

    init(books: [Book] = [],
         searchBookResult: [String] = [],
         searchExpectation: XCTestExpectation? = nil,
         bookRequestExpectation: XCTestExpectation? = nil) {
        self.books = books
        self.searchBookResult = searchBookResult
        self.searchExpectation = searchExpectation
        self.bookRequestExpectation = bookRequestExpectation
    }

    // MARK: - Methods

    // MARK: Service protocol methods

    func searchBooks(_ query: String, resultCompletion: @escaping ([String]) -> Void) {
        handledQueries.append(query)
        searchExpectation?.fulfill()
        resultCompletion(searchBookResult)
    }

    func getBook(by id: String, resultCompletion: @escaping (Book?) -> Void) {
        handledBookRequests.append(id)
        bookRequestExpectation?.fulfill()
        resultCompletion(books.first { $0.id == id })
    }

}
