//
//  RecommendationsDefaultModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 4.8.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class RecommendationsDefaultModelTests: XCTestCase {

    // MARK: - Methods

    func testFavoriteBookIDs() {
        let favoriteBooks = [MockFavoriteBook(id: "1"),
                             MockFavoriteBook(id: "2")]
        let favoriteService = FavoritesMockService(favoriteBooks: favoriteBooks)

        let model = RecommendationsServiceBasedModel(catalogueService: CatalogueTestingMockService(),
                                                     favoritesService: favoriteService)
        XCTAssertEqual(model.favoriteBookIDs, favoriteBooks.map { $0.id })
    }

    func testGetBook() {
        let bookID = "1"
        let books = [Book(authors: [], title: "Title", id: bookID, similarBookIDs: [bookID])]
        let catalogueService = CatalogueTestingMockService(books: books)

        let model = RecommendationsServiceBasedModel(catalogueService: catalogueService,
                                                     favoritesService: FavoritesMockService())

        let expecation = XCTestExpectation()
        model.getBook(by: bookID) {
            XCTAssertEqual($0!.id, bookID)
            expecation.fulfill()
        }
        wait(for: [expecation], timeout: 5.0)
    }

}
