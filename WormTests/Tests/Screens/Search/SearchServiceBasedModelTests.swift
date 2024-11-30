//
//  SearchServiceBasedModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 15.4.2024.
//

import Combine
import GoodreadsService
import Testing
@testable
import Worm

struct SearchServiceBasedModelTests {

    // MARK: - Methods

    @Test
    func books_empty_initially() {
        let model: any SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService()
        )
        #expect(model.books.isEmpty)
    }

    @Test
    func favoriteBooksIDs_empty_initially() {
        let model: any SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService()
        )
        #expect(model.favoriteBookIDs.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBooksIDs_update() async {
        let expectedIDs: Set = ["1"]
        let model: any SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService(favoriteBookIDs: expectedIDs)
        )

        var ids = model.favoriteBookIDsPublisher.values.makeAsyncIterator()
        await #expect(ids.next() == expectedIDs, "Unexpected data received.")
    }

    @Test
    func favoriteBookID_toggling_onRemovingFromFavorites() async {
        let id = "1"
        let favoritesService = FavoritesMockService(favoriteBookIDs: [id])

        let model: any SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(), favoritesService: favoritesService
        )

        var ids = model.favoriteBookIDsPublisher.values.makeAsyncIterator()
        _ = await ids.next()

        model.toggleFavoriteStateOfBook(withID: id)
        #expect(favoritesService.favoriteBookIDs.isEmpty)
    }

    @Test
    func favoriteBookID_toggling_onAddingToFavorites() async {
        let favoritesService = FavoritesMockService()
        let model: any SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(), favoritesService: favoritesService
        )

        var ids = model.favoriteBookIDsPublisher.values.makeAsyncIterator()
        _ = await ids.next()

        model.toggleFavoriteStateOfBook(withID: "1")
        #expect(!favoritesService.favoriteBookIDs.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func books_update_onSearch() async {
        let books = [
            Book(
                id: "1",
                authors: ["J.R.R. Tolkien"],
                title: "The Lord of the Rings",
                description: "Desc1",
                similarBookIDs: ["15"]
            ),
            Book(
                id: "2",
                authors: ["Michael Bond"],
                title: "Paddington Pop-Up London",
                description: "Desc2",
                similarBookIDs: ["14"]
            )
        ]

        let query = "Query"
        let result = books.map { $0.id }

        let model: any SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(books: books, queries: [query : result]),
            favoritesService: FavoritesMockService()
        )

        await model.searchBooks(by: query)
        while model.books != Set(books) {
            await Task.yield()
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func search_cancels_whenReplacedWithinDelay() async {
        let books1 = [
            Book(
                id: "1",
                authors: ["J.R.R. Tolkien"],
                title: "The Lord of the Rings",
                description: "Desc1",
                similarBookIDs: ["15"]
            ),
            Book(
                id: "2",
                authors: ["Michael Bond"],
                title: "Paddington Pop-Up London",
                description: "Desc2",
                similarBookIDs: ["14"]
            )
        ]

        let query1 = "Query1"
        let result1 = books1.map { $0.id }

        let books2 = [
            Book(
                id: "3",
                authors: ["J.K. Rowling"],
                title: "Harry Potter and the Sorcecer's Stone",
                description: "Desc1",
                similarBookIDs: ["13"]
            ),
            Book(
                id: "4",
                authors: ["George R.R. Martin"],
                title: "A Game of Thrones",
                description: "Desc2",
                similarBookIDs: ["12"]
            )
        ]

        let query2 = "Query2"
        let result2 = books2.map { $0.id }

        let model: any SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(
                books: books1 + books2,
                queries: [
                    query1 : result1,
                    query2 : result2
                ]
            ),
            favoritesService: FavoritesMockService()
        )

        await model.searchBooks(by: query2)
        await model.searchBooks(by: query1)

        while model.books != Set(books1) {
            await Task.yield()
        }
    }

}
