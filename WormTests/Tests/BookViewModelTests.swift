//
//  BookViewModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 18.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

@testable
import Worm
import XCTest

final class BookViewModelTests: XCTestCase {

    // MARK: - Methods

    func testEquals() {
        let authors = "Authors"
        let favorite = true
        let id = "ID"
        let title = "Title"

        let model1 = BookViewModel(authors: authors, favorite: favorite, id: id, title: title)
        let model2 = BookViewModel(authors: authors, favorite: favorite, id: id, title: title)

        XCTAssertEqual(model1, model2)
    }

    func testDifferentAuthors() {
        let favorite = true
        let id = "ID"
        let title = "Title"

        let authors1 = "Authors1"
        let model1 = BookViewModel(authors: authors1, favorite: favorite, id: id, title: title)

        let authors2 = "Authors2"
        let model2 = BookViewModel(authors: authors2, favorite: favorite, id: id, title: title)

        XCTAssertNotEqual(model1, model2)
    }

    func testDifferentFavoriteState() {
        let authors = "Authors"
        let id = "ID"
        let title = "Title"

        let favorite1 = true
        let model1 = BookViewModel(authors: authors, favorite: favorite1, id: id, title: title)

        let favorite2 = !favorite1
        let model2 = BookViewModel(authors: authors, favorite: favorite2, id: id, title: title)

        XCTAssertNotEqual(model1, model2)
    }

    func testDifferentID() {
        let authors = "Authors"
        let favorite = true
        let title = "Title"

        let id1 = "ID1"
        let model1 = BookViewModel(authors: authors, favorite: favorite, id: id1, title: title)

        let id2 = "ID2"
        let model2 = BookViewModel(authors: authors, favorite: favorite, id: id2, title: title)

        XCTAssertNotEqual(model1, model2)
    }

    func testDifferentTitle() {
        let authors = "Authors"
        let favorite = true
        let id = "ID"

        let title1 = "Title1"
        let model1 = BookViewModel(authors: authors, favorite: favorite, id: id, title: title1)

        let title2 = "Title2"
        let model2 = BookViewModel(authors: authors, favorite: favorite, id: id, title: title2)

        XCTAssertNotEqual(model1, model2)
    }

}
