//
//  FavoritesServiceBasedModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 21.3.2024.
//

import Combine
import GoodreadsService
@testable
import Worm
import XCTest

final class FavoritesServiceBasedModelTests: XCTestCase {

    // MARK: - Methods
    
    func testFavorites_empty_initially() {
        let model: FavoritesModel = FavoritesServiceBasedModel(catalogService: CatalogMockService(),
                                                               favoritesService: FavoritesMockService())
        XCTAssertTrue(model.favorites.isEmpty)
    }

    func testFavorites_update() {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let catalogService = CatalogMockService(books: [book])
        let favoritesService = FavoritesMockService(favoriteBookIDs: [id])

        let model: FavoritesModel = FavoritesServiceBasedModel(catalogService: catalogService,
                                                               favoritesService: favoritesService)

        let expectation = XCTestExpectation(description: "Update received")

        var cancellables = Set<AnyCancellable>()
        model
            .favoritesPublisher
            .dropFirst()
            .sink {
                XCTAssertEqual($0, [book], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testFavorites_update_onAddingFavorite() {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let catalogService = CatalogMockService(books: [book])
        let model: FavoritesModel = FavoritesServiceBasedModel(catalogService: catalogService,
                                                               favoritesService: FavoritesMockService())

        let expectation = XCTestExpectation(description: "Update received")

        var cancellables = Set<AnyCancellable>()
        model
            .favoritesPublisher
            .removeDuplicates()
            .dropFirst()
            .sink {
                XCTAssertEqual($0, [book], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        model.toggleFavoriteStateOfBook(withID: id)
        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testFavorites_update_onRemovingFavorite() {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let catalogService = CatalogMockService(books: [book])
        let favoritesService = FavoritesMockService(favoriteBookIDs: [id])

        let model: FavoritesModel = FavoritesServiceBasedModel(catalogService: catalogService,
                                                               favoritesService: favoritesService)

        let predicate = NSPredicate { model, _ in
            guard let model = model as? FavoritesModel else {
                return false
            }
            return model.favorites.isEmpty
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: model)

        model.toggleFavoriteStateOfBook(withID: id)
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: -

    private struct CatalogMockService: CatalogService {

        // MARK: - Properties

        // MARK: Private properties

        private let books: [Book]

        // MARK: - Initialization

        init(books: [Book] = []) {
            self.books = books
        }

        // MARK: - Methods

        // MARK: CatalogService protocol methods

        func searchBooks(_ query: String) async -> [String] {
            []
        }
        
        func getBook(by id: String) async -> Book? {
            books.first { $0.id == id }
        }

    }

}
