//
//  SearchServiceBasedModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 17.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
import GoodreadsService
@testable
import Worm
import XCTest

final class SearchServiceBasedModelTests: XCTestCase {

    // MARK: - Methods

    func testBooksInitiallyEmpty() {
        let model = SearchServiceBasedModel(catalogService: CatalogTestingMockService(),
                                            favoritesService: FavoritesMockService())
        XCTAssertTrue(model.books.isEmpty)
    }

    func testFavoriteBookIDsInitiallyEmpty() {
        let model = SearchServiceBasedModel(catalogService: CatalogTestingMockService(),
                                            favoritesService: FavoritesMockService())
        XCTAssertTrue(model.favoriteBookIDs.isEmpty)
    }

    func testSeachBook() {
        let catalogService = CatalogTestingMockService()
        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.SearchDefaultModelTests")
        let model = SearchServiceBasedModel(catalogService: catalogService,
                                            favoritesService: FavoritesMockService(),
                                            dispatchQueue: queue,
                                            queryDelay: nil)

        let query = "Query"
        model.searchBooks(by: query)
        queue.sync { }

        XCTAssertEqual(catalogService.handledQueries.count, 1)
        XCTAssertEqual(catalogService.handledQueries.first!, query)
    }

    func testCancelPreviousQuery() {
        let expectation = XCTestExpectation()
        let catalogService = CatalogTestingMockService(searchExpectation: expectation)

        let model = SearchServiceBasedModel(catalogService: catalogService,
                                            favoritesService: FavoritesMockService(),
                                            queryDelay: .milliseconds(100))

        let query1 = "Query1"
        model.searchBooks(by: query1)

        let query2 = "Query2"
        model.searchBooks(by: query2)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(catalogService.handledQueries.count, 1)
        XCTAssertEqual(catalogService.handledQueries.first!, query2)
    }

    func testSearchResultFiresBookRequest() {
        let result = ["1", "2"]

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = result.count

        let catalogService = CatalogTestingMockService(searchBookResult: result,
                                                           bookRequestExpectation: expectation)

        let model = SearchServiceBasedModel(catalogService: catalogService,
                                            favoritesService: FavoritesMockService(),
                                            queryDelay: nil)

        model.searchBooks(by: "Query")
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(catalogService.handledBookRequests, result)
    }

    func testToggleFavorite() {
        let model = SearchServiceBasedModel(catalogService: CatalogTestingMockService(),
                                            favoritesService: FavoritesMockService(),
                                            queryDelay: nil)

        let id = "id"
        XCTAssertFalse(model.favoriteBookIDs.contains(id))

        model.toggleFavoriteStateOfBook(withID id: id)
        XCTAssertTrue(model.favoriteBookIDs.contains(id))

        model.toggleFavoriteStateOfBook(withID id: id)
        XCTAssertFalse(model.favoriteBookIDs.contains(id))
    }

}
