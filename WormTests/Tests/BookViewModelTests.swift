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

        let model1 = BookViewModel(authors: authors, id: id, imageURL: nil, isFavorite: favorite, title: title)
        let model2 = BookViewModel(authors: authors, id: id, imageURL: nil, isFavorite: favorite, title: title)

        XCTAssertEqual(model1, model2)
    }

    func testDifferentAuthors() {
        let favorite = true
        let id = "ID"
        let title = "Title"

        let authors1 = "Authors1"
        let model1 = BookViewModel(authors: authors1, id: id, imageURL: nil, isFavorite: favorite, title: title)

        let authors2 = "Authors2"
        let model2 = BookViewModel(authors: authors2, id: id, imageURL: nil, isFavorite: favorite, title: title)

        XCTAssertNotEqual(model1, model2)
    }

    func testDifferentFavoriteState() {
        let authors = "Authors"
        let id = "ID"
        let title = "Title"

        let favorite1 = true
        let model1 = BookViewModel(authors: authors, id: id, imageURL: nil, isFavorite: favorite1, title: title)

        let favorite2 = !favorite1
        let model2 = BookViewModel(authors: authors, id: id, imageURL: nil, isFavorite: favorite2, title: title)

        XCTAssertNotEqual(model1, model2)
    }

    func testDifferentID() {
        let authors = "Authors"
        let favorite = true
        let title = "Title"

        let id1 = "ID1"
        let model1 = BookViewModel(authors: authors, id: id1, imageURL: nil, isFavorite: favorite, title: title)

        let id2 = "ID2"
        let model2 = BookViewModel(authors: authors, id: id2, imageURL: nil, isFavorite: favorite, title: title)

        XCTAssertNotEqual(model1, model2)
    }

    func testDifferentTitle() {
        let authors = "Authors"
        let favorite = true
        let id = "ID"

        let title1 = "Title1"
        let model1 = BookViewModel(authors: authors, id: id, imageURL: nil, isFavorite: favorite, title: title1)

        let title2 = "Title2"
        let model2 = BookViewModel(authors: authors, id: id, imageURL: nil, isFavorite: favorite, title: title2)

        XCTAssertNotEqual(model1, model2)
    }

}
