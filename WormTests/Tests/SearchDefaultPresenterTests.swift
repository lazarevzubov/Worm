//
//  SearchDefaultViewModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 19.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class SearchDefaultViewModelTests: XCTestCase {

    // MARK: - Methods

    func testQueryInitiallyEmpty() {
        let viewModel = SearchDefaultViewModel(model: SearchMockModel(), imageService: ImageStubService())
        XCTAssertTrue(viewModel.query.isEmpty)
    }

    func testSetQueryActivatesSearch() {
        let model = SearchMockModel()
        let viewModel = SearchDefaultViewModel(model: model, imageService: ImageStubService())
        XCTAssertNil(model.lastQuery)

        let query = "Query"
        viewModel.query = query
        XCTAssertEqual(model.lastQuery, query)
    }

    func testBookInitiallyEmpty() {
        let viewModel = SearchDefaultViewModel(model: SearchMockModel(), imageService: ImageStubService())
        XCTAssertTrue(viewModel.books.isEmpty)
    }

    func testUpdate() {
        let model = SearchMockModel()
        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.SearchDefaultViewModelTests")
        let viewModel = SearchDefaultViewModel(model: model, imageService: ImageStubService(), updateQueue: queue)

        let books = [Book(authors: [], title: "Title1", id: "1"),
                     Book(authors: [], title: "Title2", id: "2")]
        model.books = books
        queue.sync { }

        let expectedBooks = [BookViewModel(authors: "", id: "1", imageURL: nil, isFavorite: false, title: "Title1"),
                             BookViewModel(authors: "", id: "2", imageURL: nil, isFavorite: false, title: "Title2")]
        XCTAssertEqual(viewModel.books, expectedBooks)
    }

    func testToggleFavoriteState() {
        let model = SearchMockModel()

        let bookID1 = "1"
        let bookID2 = "2"
        model.favoriteBookIDs = [bookID1, bookID2]

        let viewModel = SearchDefaultViewModel(model: model, imageService: ImageStubService())

        viewModel.toggleFavoriteState(bookID: bookID1)
        XCTAssertEqual(model.favoriteBookIDs, [bookID2])

        viewModel.toggleFavoriteState(bookID: bookID1)
        XCTAssertEqual(model.favoriteBookIDs, [bookID2, bookID1])
    }

}

// MARK: -

private final class SearchMockModel: SearchModel {

    // MARK: - Properties

    private(set) var lastQuery: String?

    // MARK: SearchModel protocol properties

    @Published
    var books = [Book]()
    var favoriteBookIDs = [String]()

    // MARK: - Methods

    // MARK: SearchModel protocol methods

    func searchBooks(by query: String) {
        lastQuery = query
    }

    func toggleFavoriteState(bookID: String) {
        if favoriteBookIDs.contains(where: { $0 == bookID }) {
            favoriteBookIDs.removeAll { $0 == bookID }
        } else {
            favoriteBookIDs.append(bookID)
        }
    }

}
