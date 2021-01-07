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

    func testRecommendations() {
        let id1 = "1"
        let id2 = "2"

        let favoriteBooks = [MockFavoriteBook(id: id1),
                             MockFavoriteBook(id: id2)]
        let favoritesService = FavoritesMockService(favoriteBooks: favoriteBooks)

        let books = [Book(authors: [], title: "Title1", id: id1, similarBookIDs: [id1]),
                     Book(authors: [], title: "Title2", id: id2, similarBookIDs: [id2])]
        let catalogueService = CatalogueTestingMockService(books: books)

        let model = RecommendationsDefaultModel(catalogueService: catalogueService,
                                                favoritesService: favoritesService)

        XCTAssertEqual(Set(model.recommendations), Set(books))
    }

    func testToggleFavorite() {
        let model = RecommendationsDefaultModel(catalogueService: CatalogueTestingMockService(),
                                                favoritesService: FavoritesMockService())

        let id = "id"
        XCTAssertFalse(model.favoriteBookIDs.contains(id))

        model.toggleFavoriteState(bookID: id)
        XCTAssertTrue(model.favoriteBookIDs.contains(id))

        model.toggleFavoriteState(bookID: id)
        XCTAssertFalse(model.favoriteBookIDs.contains(id))
    }

}
