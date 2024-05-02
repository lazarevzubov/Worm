//
//  SearchServiceBasedModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 15.4.2024.
//

import Combine
import GoodreadsService
@testable
import Worm
import XCTest

final class SearchServiceBasedModelTests: XCTestCase {

    // MARK: - Methods

    func testBooks_initiallyEmpty() {
        let model: some SearchModel = SearchServiceBasedModel(catalogService: CatalogMockService(),
                                                              favoritesService: FavoritesMockService())
        XCTAssertTrue(model.books.isEmpty)
    }

    func testBooks_update_onSearch() async {
        let books = [Book(authors: ["J.R.R. Tolkien"],
                          title: "The Lord of the Rings",
                          id: "1",
                          similarBookIDs: ["15"]),
                     Book(authors: ["Michael Bond"],
                          title: "Paddington Pop-Up London",
                          id: "2",
                          similarBookIDs: ["14"])]

        let query = "Query"
        let result = books.map { $0.id }

        let model: some SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(books: books, queries: [query : result]),
            favoritesService: FavoritesMockService()
        )

        let predicate = NSPredicate { model, _ in
            guard let model = model as? SearchModel else {
                return false
            }
            return model.books == Set(books)
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: model)

        await model.searchBooks(by: query)
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testSearch_cancels_whenReplacedWithinDelay() async {
        let books1 = [Book(authors: ["J.R.R. Tolkien"],
                           title: "The Lord of the Rings",
                           id: "1",
                           similarBookIDs: ["15"]),
                      Book(authors: ["Michael Bond"],
                           title: "Paddington Pop-Up London",
                           id: "2",
                           similarBookIDs: ["14"])]

        let query1 = "Query1"
        let result1 = books1.map { $0.id }

        let books2 = [Book(authors: ["J.K. Rowling"],
                           title: "Harry Potter and the Sorcecer's Stone",
                           id: "3",
                           similarBookIDs: ["13"]),
                      Book(authors: ["George R.R. Martin"],
                           title: "A Game of Thrones",
                           id: "4",
                           similarBookIDs: ["12"])]

        let query2 = "Query2"
        let result2 = books2.map { $0.id }

        let model: some SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(books: books1 + books2, queries: [query1 : result1,
                                                                                 query2 : result2]),
            favoritesService: FavoritesMockService()
        )

        let predicate = NSPredicate { model, _ in
            guard let model = model as? SearchModel else {
                return false
            }
            return model.books == Set(books1)
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: model)

        await model.searchBooks(by: query2)
        await model.searchBooks(by: query1)

        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testFavoriteBooksIDs_initiallyEmpty() {
        let model: some SearchModel = SearchServiceBasedModel(catalogService: CatalogMockService(),
                                                              favoritesService: FavoritesMockService())
        XCTAssertTrue(model.favoriteBookIDs.isEmpty)
    }

    func testFavoriteBooksIDs_update() {
        let ids: Set = ["1"]
        let model: some SearchModel = SearchServiceBasedModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService(favoriteBookIDs: ids)
        )

        let expectation = XCTestExpectation(description: "Update received.")

        var cancellables = Set<AnyCancellable>()
        model
            .favoriteBookIDsPublisher
            .sink {
                XCTAssertEqual($0, ids, "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testFavoriteBookID_toggling_onRemovingFromFavorites() {
        let id = "1"
        let favoritesService = FavoritesMockService(favoriteBookIDs: [id])

        let model: some SearchModel = SearchServiceBasedModel(catalogService: CatalogMockService(),
                                                              favoritesService: favoritesService)

        let expectation = expectation(description: "Update received.")
        expectation.assertForOverFulfill = false

        var cancellables = Set<AnyCancellable>()
        model
            .favoriteBookIDsPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)

        model.toggleFavoriteStateOfBook(withID: id)
        XCTAssertTrue(favoritesService.favoriteBookIDs.isEmpty)

        cancellables.forEach { $0.cancel() }
    }

    func testFavoriteBookID_toggling_onAddingToFavorites() {
        let favoritesService = FavoritesMockService()
        let model: some SearchModel = SearchServiceBasedModel(catalogService: CatalogMockService(),
                                                              favoritesService: favoritesService)

        let expectation = expectation(description: "Update received.")
        expectation.assertForOverFulfill = false

        var cancellables = Set<AnyCancellable>()
        model
            .favoriteBookIDsPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)

        model.toggleFavoriteStateOfBook(withID: "1")
        XCTAssertFalse(favoritesService.favoriteBookIDs.isEmpty)

        cancellables.forEach { $0.cancel() }
    }

}
