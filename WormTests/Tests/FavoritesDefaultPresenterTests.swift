//
//  FavoritesDefaultViewModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 25.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class FavoritesDefaultViewModelTests: XCTestCase {

    // MARK: - Methods

    func testToggleFavoriteState() {
        let model = FavoritesMockModel()
        let viewModel = FavoritesDefaultViewModel(model: model, imageService: ImageStubService())

        XCTAssertTrue(model.toggledBookIDs.isEmpty)

        let bookID = "1"
        viewModel.toggleFavoriteStateOfBook(withID id: bookID)
        XCTAssertEqual(model.toggledBookIDs, [bookID])
    }

    func testFavoritesInitiallyEmpty() {
        let model = FavoritesMockModel()
        let viewModel = FavoritesDefaultViewModel(model: model, imageService: ImageStubService())

        XCTAssertTrue(viewModel.favorites.isEmpty)
    }

    func testFavoritesUpdate() {
        let model = FavoritesMockModel()
        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.FavoritesDefaultViewModelTests")
        let viewModel = FavoritesDefaultViewModel(model: model, imageService: ImageStubService(), updateQueue: queue)

        XCTAssertTrue(viewModel.favorites.isEmpty)

        let book = Book(authors: ["Author"], title: "Title", id: "1")
        model.favorites.append(book)

        queue.sync {
            // Wait for update.
        }

        XCTAssertEqual(viewModel.favorites, [book.asViewModel(favorite: true)])
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

    func toggleFavoriteStateOfBook(withID id: String) {
        toggledBookIDs.append(withID id)
    }


}
