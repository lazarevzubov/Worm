//
//  RecommendationsDefaultModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 6.4.2024.
//

import Combine
import GoodreadsService
@testable
import Worm
import XCTest

final class RecommendationsDefaultModelTests: XCTestCase {

    // MARK: - Methods

    func testFavoriteBookIDs_initiallyEmpty() {
        let model = RecommendationsDefaultModel(catalogService: CatalogMockService(),
                                                favoritesService: FavoritesMockService())
        XCTAssertTrue(model.favoriteBookIDs.isEmpty)
    }

    func testRecommendations_initiallyEmpty() {
        let model = RecommendationsDefaultModel(catalogService: CatalogMockService(),
                                                favoritesService: FavoritesMockService())
        XCTAssertTrue(model.recommendations.isEmpty)
    }

    func testFavoriteBookIDs_update() {
        let id = "1"
        let model: RecommendationsModel = RecommendationsDefaultModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService(favoriteBookIDs: [id])
        )

        let expectation = XCTestExpectation(description: "Update received.")

        var cancellables = Set<AnyCancellable>()
        model
            .favoriteBookIDsPublisher
            .dropFirst()
            .sink {
                XCTAssertEqual($0, [id], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testFavoriteBookIDs_update_onAddingFavorite() async {
        let model: RecommendationsModel = RecommendationsDefaultModel(catalogService: CatalogMockService(),
                                                                      favoritesService: FavoritesMockService())

        let expectation = XCTestExpectation(description: "Update received.")
        let id = "1"

        var cancellables = Set<AnyCancellable>()
        model
            .favoriteBookIDsPublisher
            .dropFirst(2)
            .sink {
                XCTAssertEqual($0, [id], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await model.toggleFavoriteStateOfBook(withID: id)
        await fulfillment(of: [expectation], timeout: 2.0)

        cancellables.forEach { $0.cancel() }
    }

    func testFavoriteBookIDs_update_onRemovingFavorite() async {
        let id = "1"
        let model: RecommendationsModel = RecommendationsDefaultModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService(favoriteBookIDs: [id])
        )

        let updateExpectation = XCTestExpectation(description: "Update received.")
        let editingExpectation = XCTestExpectation(description: "Update after editing received.")

        var callCount = 0
        var cancellables = Set<AnyCancellable>()
        model
            .favoriteBookIDsPublisher
            .dropFirst()
            .sink {
                if callCount == 0 {
                    updateExpectation.fulfill()
                    callCount += 1
                } else {
                    XCTAssertTrue($0.isEmpty, "Unexpected data received.")
                    editingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await fulfillment(of: [updateExpectation], timeout: 1.0)

        await model.toggleFavoriteStateOfBook(withID: id)
        await fulfillment(of: [editingExpectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testRecommendations_update() {
        let book = Book(authors: ["J.R.R. Tolkien"],
                        title: "The Lord of the Rings",
                        id: "1",
                        similarBookIDs: ["15"])
        let recommendedBook = Book(authors: ["Haruki Murakami"],
                                   title: "The Wind-Up Bird Chronicle",
                                   id: "15",
                                   similarBookIDs: ["1"])

        let model: RecommendationsModel = RecommendationsDefaultModel(
            catalogService: CatalogMockService(books: [book,
                                                       recommendedBook]),
            favoritesService: FavoritesMockService(favoriteBookIDs: ["1"])
        )

        let expectation = XCTestExpectation(description: "Update received.")

        var cancellables = Set<AnyCancellable>()
        model
            .recommendationsPublisher
            .dropFirst()
            .sink {
                XCTAssertEqual($0, [recommendedBook], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)

        cancellables.forEach { $0.cancel() }
    }

    func testRecommendations_update_onAddingFavorite() async {
        let book = Book(authors: ["J.R.R. Tolkien"],
                        title: "The Lord of the Rings",
                        id: "1",
                        similarBookIDs: ["15"])
        let recommendedBook = Book(authors: ["Haruki Murakami"],
                                   title: "The Wind-Up Bird Chronicle",
                                   id: "15",
                                   similarBookIDs: ["1"])

        let model: RecommendationsModel = RecommendationsDefaultModel(
            catalogService: CatalogMockService(books: [book,
                                                       recommendedBook]),
            favoritesService: FavoritesMockService()
        )

        let expectation = XCTestExpectation(description: "Update received.")

        var cancellables = Set<AnyCancellable>()
        model
            .recommendationsPublisher
            .dropFirst()
            .sink {
                XCTAssertEqual($0, [recommendedBook], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await model.toggleFavoriteStateOfBook(withID: "1")
        await fulfillment(of: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testRecommendations_update_onRemovingFavorite() async {
        let book = Book(authors: ["J.R.R. Tolkien"],
                        title: "The Lord of the Rings",
                        id: "1",
                        similarBookIDs: ["15"])
        let recommendedBook = Book(authors: ["Haruki Murakami"],
                                   title: "The Wind-Up Bird Chronicle",
                                   id: "15",
                                   similarBookIDs: ["1"])

        let model: RecommendationsModel = RecommendationsDefaultModel(
            catalogService: CatalogMockService(books: [book,
                                                       recommendedBook]),
            favoritesService: FavoritesMockService(favoriteBookIDs: [book.id])
        )

        let expectation = XCTestExpectation(description: "Update received.")

        var cancellables = Set<AnyCancellable>()
        model
            .recommendationsPublisher
            .dropFirst(2)
            .sink {
                XCTAssertTrue($0.isEmpty, "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        try? await Task.sleep(for: .seconds(1)) // Imitates a separate update, after initialization.
        await model.toggleFavoriteStateOfBook(withID: book.id)
        await fulfillment(of: [expectation], timeout: 2.0)

        cancellables.forEach { $0.cancel() }
    }

    func testRecommendations_update_onBlockingRecommendation() {
        let book = Book(authors: ["J.R.R. Tolkien"],
                        title: "The Lord of the Rings",
                        id: "1",
                        similarBookIDs: ["15"])
        let recommendedBook = Book(authors: ["Haruki Murakami"],
                                   title: "The Wind-Up Bird Chronicle",
                                   id: "15",
                                   similarBookIDs: ["1"])

        let model: RecommendationsModel = RecommendationsDefaultModel(
            catalogService: CatalogMockService(books: [book,
                                                       recommendedBook]),
            favoritesService: FavoritesMockService(favoriteBookIDs: [book.id])
        )

        let expectation = XCTestExpectation(description: "Update received.")

        var cancellables = Set<AnyCancellable>()
        model
            .recommendationsPublisher
            .dropFirst(2)
            .sink {
                XCTAssertTrue($0.isEmpty, "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        Task {
            try? await Task.sleep(for: .seconds(1)) // Imitates a separate update, after initialization.
            model.blockFromRecommendationsBook(withID: recommendedBook.id)
        }
        wait(for: [expectation], timeout: 2.0)

        cancellables.forEach { $0.cancel() }
    }

    func testBlockingRecommendation_updatesBlockedBooks() {
        let favoritesService = FavoritesMockService()
        let model: RecommendationsModel = RecommendationsDefaultModel(catalogService: CatalogMockService(),
                                                                      favoritesService: favoritesService)

        let id = "1"
        model.blockFromRecommendationsBook(withID: id)

        XCTAssertTrue(favoritesService.blockedBookIDs.contains(id))
    }

}
