//
//  FavoritesPersistenceServiceTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 27.4.2024.
//

import Combine
import SwiftData
@testable
import Worm
import XCTest

final class FavoritesPersistenceServiceTests: XCTestCase {

    // MARK: - Methods

    func testBlockedBookIDs_initiallyEmpty() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = FavoritesPersistenceService(modelContainer: modelContainer)
        XCTAssertTrue(service.blockedBookIDs.isEmpty)
    }

    func testBlockedBookIDs_update() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let id = "ID"
        let blockedBook = BlockedBook(id: id)

        let context = ModelContext(modelContainer)
        context.insert(blockedBook)
        try context.save()

        let service = FavoritesPersistenceService(modelContainer: modelContainer)

        let expectation = XCTestExpectation(description: "Update received.")

        var cancellables = Set<AnyCancellable>()
        service
            .blockedBookIDsPublisher
            .sink {
                XCTAssertEqual($0, [id], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testBlockedBookIDs_adding() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = FavoritesPersistenceService(modelContainer: modelContainer)

        let expectation = XCTestExpectation(description: "Update received.")
        var cancellables = Set<AnyCancellable>()

        let id = "ID"
        service
            .blockedBookIDsPublisher
            .dropFirst()
            .sink {
                XCTAssertEqual($0, [id], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        service.addToBlockedBook(withID: id)
        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testFavoriteBookIDs_initiallyEmpty() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = FavoritesPersistenceService(modelContainer: modelContainer)
        XCTAssertTrue(service.favoriteBookIDs.isEmpty)
    }

    func testFavoriteBookIDs_update() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let id = "ID"
        let favoriteBook = FavoriteBook(id: id)

        let context = ModelContext(modelContainer)
        context.insert(favoriteBook)
        try context.save()

        let service = FavoritesPersistenceService(modelContainer: modelContainer)

        let expectation = XCTestExpectation(description: "Update received.")

        var cancellables = Set<AnyCancellable>()
        service
            .favoriteBookIDsPublisher
            .sink {
                XCTAssertEqual($0, [id], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testFavoriteBookIDs_adding() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = FavoritesPersistenceService(modelContainer: modelContainer)

        let expectation = XCTestExpectation(description: "Update received.")
        var cancellables = Set<AnyCancellable>()

        let id = "ID"
        service
            .favoriteBookIDsPublisher
            .dropFirst()
            .sink {
                XCTAssertEqual($0, [id], "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        service.addToFavoritesBook(withID: id)
        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    func testFavoriteBookIDs_removing() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let id = "ID"
        let favoriteBook = FavoriteBook(id: id)

        let context = ModelContext(modelContainer)
        context.insert(favoriteBook)
        try context.save()

        let service = FavoritesPersistenceService(modelContainer: modelContainer)

        let expectation = XCTestExpectation(description: "Update received.")
        var cancellables = Set<AnyCancellable>()

        service
            .favoriteBookIDsPublisher
            .dropFirst()
            .sink {
                XCTAssertTrue($0.isEmpty, "Unexpected data received.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        service.removeFromFavoriteBook(withID: id)
        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

}
