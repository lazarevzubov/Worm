//
//  SearchDefaultPresenterTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 19.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class SearchDefaultPresenterTests: XCTestCase {

    // MARK: - Methods

    func testQueryInitiallyEmpty() {
        let presenter = SearchDefaultPresenter(model: SearchMockModel(), imageService: ImageStubService())
        XCTAssertTrue(presenter.query.isEmpty)
    }

    func testSetQueryActivatesSearch() {
        let model = SearchMockModel()
        let presenter = SearchDefaultPresenter(model: model, imageService: ImageStubService())
        XCTAssertNil(model.lastQuery)

        let query = "Query"
        presenter.query = query
        XCTAssertEqual(model.lastQuery, query)
    }

    func testBookInitiallyEmpty() {
        let presenter = SearchDefaultPresenter(model: SearchMockModel(), imageService: ImageStubService())
        XCTAssertTrue(presenter.books.isEmpty)
    }

    func testUpdate() {
        let model = SearchMockModel()
        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.SearchDefaultPresenterTests")
        let presenter = SearchDefaultPresenter(model: model, imageService: ImageStubService(), updateQueue: queue)

        let books = [Book(authors: [], title: "Title1", id: "1"),
                     Book(authors: [], title: "Title2", id: "2")]
        model.books = books
        queue.sync { }

        let expectedBooks = [BookViewModel(authors: "", id: "1", imageURL: nil, isFavorite: false, title: "Title1"),
                             BookViewModel(authors: "", id: "2", imageURL: nil, isFavorite: false, title: "Title2")]
        XCTAssertEqual(presenter.books, expectedBooks)
    }

    func testToggleFavoriteState() {
        let model = SearchMockModel()

        let bookID1 = "1"
        let bookID2 = "2"
        model.favoriteBookIDs = [bookID1, bookID2]

        let presenter = SearchDefaultPresenter(model: model, imageService: ImageStubService())

        presenter.toggleFavoriteState(bookID: bookID1)
        XCTAssertEqual(model.favoriteBookIDs, [bookID2])

        presenter.toggleFavoriteState(bookID: bookID1)
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
