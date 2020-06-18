//
//  MainDefaultModelTests.swift
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

final class MainDefaultModelTests: XCTestCase {

    // MARK: - Methods

    func testBooksInitiallyEmpty() {
        let catalogueService = CatalogueTestingMockService()

        let persistenceContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let favoritesService = FavoritesService(persistenceContext: persistenceContext)
        
        let model = MainServiceBasedModel(catalogueService: catalogueService, favoritesService: favoritesService)

        XCTAssertTrue(model.books.isEmpty)
    }

    func testFavoriteBookIDsInitiallyEmpty() {
        let catalogueService = CatalogueTestingMockService()

        let persistenceContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let favoritesService = FavoritesService(persistenceContext: persistenceContext)

        let model = MainServiceBasedModel(catalogueService: catalogueService, favoritesService: favoritesService)

        XCTAssertTrue(model.favoriteBookIDs.isEmpty)
    }

    func testSeachBook() {
        let catalogueService = CatalogueTestingMockService()

        let persistenceContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let favoritesService = FavoritesService(persistenceContext: persistenceContext)

        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.MainDefaultModelTests")

        let model = MainServiceBasedModel(catalogueService: catalogueService,
                                          favoritesService: favoritesService,
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
        let catalogueService = CatalogueTestingMockService(searchExpectation: expectation)

        let persistenceContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let favoritesService = FavoritesService(persistenceContext: persistenceContext)

        let model = MainServiceBasedModel(catalogueService: catalogueService,
                                          favoritesService: favoritesService,
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

        let catalogueService = CatalogueTestingMockService(searchBookResult: result,
                                                           bookRequestExpectation: expectation)

        let persistenceContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let favoritesService = FavoritesService(persistenceContext: persistenceContext)

        let model = MainServiceBasedModel(catalogueService: catalogueService,
                                          favoritesService: favoritesService,
                                          queryDelay: nil)

        model.searchBooks(by: "Query")
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(catalogueService.handledBookRequests, result)
    }

    func testToggleFavorite() {
        let catalogueService = CatalogueTestingMockService()

        let persistenceContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let favoritesService = FavoritesService(persistenceContext: persistenceContext)

        let model = MainServiceBasedModel(catalogueService: catalogueService,
                                          favoritesService: favoritesService,
                                          queryDelay: nil)

        let id = "id"
        XCTAssertFalse(model.favoriteBookIDs.contains(id))

        model.toggleFavoriteState(bookID: id)
        XCTAssertTrue(model.favoriteBookIDs.contains(id))

        model.toggleFavoriteState(bookID: id)
        XCTAssertFalse(model.favoriteBookIDs.contains(id))
    }

}
