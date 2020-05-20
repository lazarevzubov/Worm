//
//  MainDefaultPresenterTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 19.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class MainDefaultPresenterTests: XCTestCase {

    // MARK: - Methods

    func testQueryInitiallyEmpty() {
        let presenter = MainDefaultPresenter(model: MainMockModel())
        XCTAssertTrue(presenter.query.isEmpty)
    }

    func testSetQueryActivatesSearch() {
        let model = MainMockModel()
        let presenter = MainDefaultPresenter(model: model)
        XCTAssertNil(model.lastQuery)

        let query = "Query"
        presenter.query = query
        XCTAssertEqual(model.lastQuery, query)
    }

    func testBookInitiallyEmpty() {
        let presenter = MainDefaultPresenter(model: MainMockModel())
        XCTAssertTrue(presenter.books.isEmpty)
    }

}

// MARK: -

private final class MainMockModel: MainModel {

    // MARK: - Properties

    private(set) var lastQuery: String?

    // MARK: MainModel protocol properties

    @Published
    var books = [Book]()

    // MARK: - Methods

    // MARK: MainModel protocol methods

    func searchBooks(by query: String) {
        lastQuery = query
    }

}
