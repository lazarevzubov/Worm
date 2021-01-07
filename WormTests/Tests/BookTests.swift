//
//  BookTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 17.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class BookTests: XCTestCase {

    // MARK: - Methods

    func testViewModelAuthors() {
        let author1 = "Author1"
        let author2 = "Author2"
        let book = Book(authors: [author1, author2], title: "Title", id: "id")

        let vm = book.asViewModel(favorite: true)
        XCTAssertEqual(vm.authors, "\(author1), \(author2)")
    }

    func testViewModelEmptyAuthors() {
        let book = Book(authors: [], title: "Title", id: "id")

        let vm = book.asViewModel(favorite: true)
        XCTAssertTrue(vm.authors.isEmpty)
    }

    func testViewModelFavorite() {
        let book = Book(authors: [], title: "Title", id: "id")

        let vm = book.asViewModel(favorite: true)
        XCTAssertTrue(vm.isFavorite)
    }

    func testViewModelNotFavorite() {
        let book = Book(authors: [], title: "Title", id: "id")

        let vm = book.asViewModel(favorite: false)
        XCTAssertFalse(vm.isFavorite)
    }

    func testViewModelID() {
        let id = "id"
        let book = Book(authors: [], title: "Title", id: id)

        let vm = book.asViewModel(favorite: true)
        XCTAssertEqual(vm.id, id)
    }

    func testViewModelTitle() {
        let title = "Title"
        let book = Book(authors: [], title: title, id: "id")

        let vm = book.asViewModel(favorite: true)
        XCTAssertEqual(vm.title, title)
    }

}
