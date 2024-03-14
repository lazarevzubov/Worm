//
//  BookViewModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 27.4.2024.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class BookViewModelTests: XCTestCase {

    // MARK: - Methods

    func testAuthors() {
        let author1 = "Author1"
        let author2 = "Author2"
        let book = Book(authors: [author1,
                                  author2],
                        title: "Title",
                        id: "ID",
                        imageURL: URL(string: "https://apple.com")!,
                        similarBookIDs: ["ID1",
                                         "ID2"])

        let vm = BookViewModel(book: book, favorite: true)
        XCTAssertEqual(vm.authors, "\(author1), \(author2)")
    }

    func testID() {
        let id = "ID"
        let book = Book(authors: ["Author1",
                                  "Author2"],
                        title: "Title",
                        id: id,
                        imageURL: URL(string: "https://apple.com")!,
                        similarBookIDs: ["ID1",
                                         "ID2"])

        let vm = BookViewModel(book: book, favorite: true)
        XCTAssertEqual(vm.id, id)
    }

    func testImageURL() {
        let imageURL = URL(string: "https://apple.com")!
        let book = Book(authors: ["Author1",
                                  "Author2"],
                        title: "Title",
                        id: "ID",
                        imageURL: imageURL,
                        similarBookIDs: ["ID1",
                                         "ID2"])

        let vm = BookViewModel(book: book, favorite: true)
        XCTAssertEqual(vm.imageURL, imageURL)
    }

    func testFavorite() {
        let book = Book(authors: ["Author1",
                                  "Author2"],
                        title: "Title",
                        id: "ID",
                        imageURL: URL(string: "https://apple.com")!,
                        similarBookIDs: ["ID1",
                                         "ID2"])

        let favorite = true
        let vm = BookViewModel(book: book, favorite: favorite)

        XCTAssertEqual(vm.favorite, favorite)
    }

    func testTitle() {
        let title = "Title"
        let book = Book(authors: ["Author1",
                                  "Author2"],
                        title: title,
                        id: "ID",
                        imageURL: URL(string: "https://apple.com")!,
                        similarBookIDs: ["ID1",
                                         "ID2"])

        let vm = BookViewModel(book: book, favorite: true)
        XCTAssertEqual(vm.title, title)
    }

}
