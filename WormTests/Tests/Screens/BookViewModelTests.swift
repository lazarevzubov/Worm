//
//  BookViewModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 27.4.2024.
//

import Foundation
import GoodreadsService
import Testing
@testable
import Worm

struct BookViewModelTests {

    // MARK: - Methods

    @Test
    func id_asProvided() {
        let id = "ID"
        let book = Book(
            id: id,
            authors: [
                "Author1",
                "Author2"
            ],
            title: "Title",
            description: "Desc",
            imageURL: URL(string: "https://apple.com")!,
            similarBookIDs: [
                "ID1",
                "ID2"
            ]
        )

        let vm = BookViewModel(book: book, favorite: true)
        #expect(vm.id == id)
    }

    @Test
    func authors_asProvided() {
        let author1 = "Author1"
        let author2 = "Author2"
        let book = Book(
            id: "ID",
            authors: [
                author1,
                author2
            ],
            title: "Title",
            description: "Desc",
            imageURL: URL(string: "https://apple.com")!,
            similarBookIDs: [
                "ID1",
                "ID2"
            ]
        )

        let vm = BookViewModel(book: book, favorite: true)
        #expect(vm.authors == "\(author1), \(author2)")
    }

    @Test
    func imageURL_asProvided() {
        let imageURL = URL(string: "https://apple.com")!
        let book = Book(
            id: "ID",
            authors: [
                "Author1",
                "Author2"
            ],
            title: "Title",
            description: "Desc",
            imageURL: imageURL,
            similarBookIDs: [
                "ID1",
                "ID2"
            ]
        )

        let vm = BookViewModel(book: book, favorite: true)
        #expect(vm.imageURL == imageURL)
    }

    @Test
    func favorite_asProvided() {
        let book = Book(
            id: "ID",
            authors: [
                "Author1",
                "Author2"
            ],
            title: "Title",
            description: "Desc",
            imageURL: URL(string: "https://apple.com")!,
            similarBookIDs: [
                "ID1",
                "ID2"
            ]
        )

        let favorite = true
        let vm = BookViewModel(book: book, favorite: favorite)

        #expect(vm.favorite == favorite)
    }

    @Test
    func title_asProvided() {
        let title = "Title"
        let book = Book(
            id: "ID",
            authors: [
                "Author1",
                "Author2"
            ],
            title: title,
            description: "Desc",
            imageURL: URL(string: "https://apple.com")!,
            similarBookIDs: [
                "ID1",
                "ID2"
            ]
        )

        let vm = BookViewModel(book: book, favorite: true)
        #expect(vm.title == title)
    }

    @Test
    func rating_whenBookRating_nil_thenNil() {
        let book = Book(
            id: "ID",
            authors: [
                "Author1",
                "Author2"
            ],
            title: "Title",
            description: "Desc",
            rating: nil,
            imageURL: URL(string: "https://apple.com")!,
            similarBookIDs: [
                "ID1",
                "ID2"
            ]
        )

        let vm = BookViewModel(book: book, favorite: true)
        #expect(vm.rating == nil)
    }

    @Test
    func rating_whenBookRating_notNil_thenFormattedWithTwoDecimals() {
        let book = Book(
            id: "ID",
            authors: [
                "Author1",
                "Author2"
            ],
            title: "Title",
            description: "Desc",
            rating: 1.234,
            imageURL: URL(string: "https://apple.com")!,
            similarBookIDs: [
                "ID1",
                "ID2"
            ]
        )

        let vm = BookViewModel(book: book, favorite: true)
        #expect(vm.rating == "1.23")
    }

}
