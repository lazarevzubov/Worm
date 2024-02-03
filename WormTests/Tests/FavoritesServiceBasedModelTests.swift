//
//  FavoritesServiceBasedModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 15.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

@testable
import Worm
import XCTest

final class FavoritesServiceBasedModelTests: XCTestCase {

    // MARK: - Methods

    func testFavoritesInitiallyEmpty() {
        let model = FavoritesServiceBasedModel(catalogService: CatalogMockService(),
                                               favoritesService: FavoritesMockService())
        XCTAssertTrue(model.favorites.isEmpty)
    }

    func testFavoritesInitialUpdate() {
        let catalogService = CatalogMockService()

        let favorites = [MockFavoriteBook(id: "1"),
                         MockFavoriteBook(id: "2")]
        let favoritesService = FavoritesMockService(favoriteBooks: favorites)

        let model = FavoritesServiceBasedModel(catalogService: catalogService, favoritesService: favoritesService)
        XCTAssertEqual(model.favorites.map { $0.id }, favorites.map { $0.id })
    }

    func testToggleNotFavorite() {
        let catalogService = CatalogMockService()
        let favoritesService = FavoritesMockService()
        let model = FavoritesServiceBasedModel(catalogService: catalogService, favoritesService: favoritesService)

        XCTAssertTrue(favoritesService.favoriteBooks.isEmpty)
        XCTAssertTrue(model.favorites.isEmpty)

        let id = "1"
        model.toggleFavoriteStateOfBook(withID id: id)
        XCTAssertEqual(favoritesService.favoriteBooks.map { $0.id }, [MockFavoriteBook(id: id)].map { $0.id })
        XCTAssertEqual(model.favorites.map { $0.id }, [id])
    }

    func testToggleFavorite() {
        let catalogService = CatalogMockService()

        let id1 = "1"
        let id2 = "2"
        let favorites = [MockFavoriteBook(id: id1),
                         MockFavoriteBook(id: id2)]
        let favoritesService = FavoritesMockService(favoriteBooks: favorites)

        let model = FavoritesServiceBasedModel(catalogService: catalogService, favoritesService: favoritesService)
        XCTAssertEqual(model.favorites.map { $0.id }, favorites.map { $0.id })

        model.toggleFavoriteStateOfBook(withID id: id1)
        XCTAssertEqual(favoritesService.favoriteBooks.map { $0.id }, [MockFavoriteBook(id: id2)].map { $0.id })
        XCTAssertEqual(model.favorites.map { $0.id }, [id2])
    }

}
