//
//  FavoritesDefaultPresenterTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 25.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class FavoritesDefaultPresenterTests: XCTestCase {

    // MARK: - Methods

    func testToggleFavoriteState() {
        let model = FavoritesMockModel()
        let presenter = FavoritesDefaultPresenter(model: model)

        XCTAssertTrue(model.toggledBookIDs.isEmpty)

        let bookID = "1"
        presenter.toggleFavoriteState(bookID: bookID)
        XCTAssertEqual(model.toggledBookIDs, [bookID])
    }

    func testFavoritesInitiallyEmpty() {
        let model = FavoritesMockModel()
        let presenter = FavoritesDefaultPresenter(model: model)

        XCTAssertTrue(presenter.favorites.isEmpty)
    }

    func testFavoritesUpdate() {
        let model = FavoritesMockModel()
        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.FavoritesDefaultPresenterTests")
        let presenter = FavoritesDefaultPresenter(model: model, updateQueue: queue)

        XCTAssertTrue(presenter.favorites.isEmpty)

        let book = Book(authors: ["Author"], title: "Title", id: "1")
        model.favorites.append(book)

        queue.sync {
            // Wait for update.
        }

        XCTAssertEqual(presenter.favorites, [book.asViewModel(favorite: true)])
    }

}

// MARK: -

private class FavoritesMockModel: FavoritesModel {

    // MARK: - Properties

    private(set) var toggledBookIDs: [String] = []

    // MARK: FavoritesModel protocol properties

    @Published
    var favorites: [Book] = []

    // MARK: - Methods

    // MARK: FavoritesModel protocol methods

    func toggleFavoriteState(bookID: String) {
        toggledBookIDs.append(bookID)
    }


}
