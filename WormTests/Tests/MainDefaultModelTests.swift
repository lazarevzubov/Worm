//
//  MainDefaultModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 17.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class MainDefaultModelTests: XCTestCase {

    // MARK: - Methods

    func testBooksInitiallyEmpty() {
        let model = MainServiceBasedModel(catalogueService: CatalogueMockService(),
                                          persistenseService: FavoritesStubService())
        XCTAssertTrue(model.books.isEmpty)
    }

    func testSeachBook() {
        let catalogueService = CatalogueMockService()
        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.MainDefaultModelTests")
        let model = MainServiceBasedModel(catalogueService: catalogueService,
                                          persistenseService: FavoritesStubService(),
                                          dispatchQueue: queue,
                                          queryDelay: nil)

        let query = "Query"
        model.searchBooks(by: query)
        queue.sync { }

        XCTAssertEqual(catalogueService.handledQueries.count, 1)
        XCTAssertEqual(catalogueService.handledQueries.first!, query)
    }

    func testCancelPreviousQuery() {
        let expectation = XCTestExpectation()
        let catalogueService = CatalogueMockService(searchExpectation: expectation)
        let model = MainServiceBasedModel(catalogueService: catalogueService,
                                          persistenseService: FavoritesStubService(),
                                          queryDelay: .milliseconds(100))

        let query1 = "Query1"
        model.searchBooks(by: query1)

        let query2 = "Query2"
        model.searchBooks(by: query2)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(catalogueService.handledQueries.count, 1)
        XCTAssertEqual(catalogueService.handledQueries.first!, query2)
    }

    func testSearchResultFiresBookRequest() {
        let result = ["1", "2"]

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = result.count

        let catalogueService = CatalogueMockService(searchBookResult: result, bookRequestExpectation: expectation)
        let model = MainServiceBasedModel(catalogueService: catalogueService,
                                          persistenseService: FavoritesStubService(),
                                          queryDelay: nil)

        model.searchBooks(by: "Query")
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(catalogueService.handledBookRequests, result)
    }

}

// MARK: -

private final class CatalogueMockService: CatalogueService {

    // MARK: - Properties

    let searchBookResult: [String]
    private(set) var handledBookRequests = [String]()
    private(set) var handledQueries = [String]()

    // MARK: Private properties

    private let bookRequestExpectation: XCTestExpectation?
    private var searchExpectation: XCTestExpectation?

    // MARK: - Initialization

    init(searchBookResult: [String] = [],
         searchExpectation: XCTestExpectation? = nil,
         bookRequestExpectation: XCTestExpectation? = nil) {
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
    }

}

// MARK: -

private final class FavoritesStubService: FavoritesService {

    // MARK: - Properties

    // MARK: FavoritesService protocol properties

    let favoriteBooks = [FavoriteBook]()

    // MARK: - Methods

    // MARK: - FavoritesService protocol methods

    func addToFavoriteBooks(_ id: String) {
        // Do nothing.
    }

    func removeFromFavoriteBooks(_ id: String) {
        // Do nothing.
    }

}
