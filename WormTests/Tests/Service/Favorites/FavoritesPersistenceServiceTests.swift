//
//  FavoritesPersistenceServiceTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 27.4.2024.
//

import Combine
import SwiftData
import Testing
@testable
import Worm

struct FavoritesPersistenceServiceTests {

    // MARK: - Methods

    @Test
    func blockedBookIDs_empty_initially() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = FavoritesPersistenceService(modelContainer: modelContainer)
        #expect(service.blockedBookIDs.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func blockedBookIDs_update() async throws {
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
        var ids = service.blockedBookIDsPublisher.values.makeAsyncIterator()

        await #expect(ids.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func blockedBookIDs_update_onAdding() async throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = FavoritesPersistenceService(modelContainer: modelContainer)
        var ids = service.blockedBookIDsPublisher.dropFirst().values.makeAsyncIterator()

        let id = "ID"
        service.addToBlockedBook(withID: id)

        await #expect(ids.next() == [id], "Unexpected data received.")
    }

    @Test
    func favoriteBookIDs_empty_initially() throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = FavoritesPersistenceService(modelContainer: modelContainer)
        #expect(service.favoriteBookIDs.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_update() async throws {
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
        var ids = service.favoriteBookIDsPublisher.values.makeAsyncIterator()

        await #expect(ids.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_update_onAdding() async throws {
        let schema = Schema(
            [BlockedBook.self,
             FavoriteBook.self],
            version: Schema.Version(1, 0, 0)
        )
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = FavoritesPersistenceService(modelContainer: modelContainer)
        var ids = service.favoriteBookIDsPublisher.dropFirst().values.makeAsyncIterator()

        let id = "ID"
        service.addToFavoritesBook(withID: id)

        await #expect(ids.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_update_onRemoving() async throws {
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
        var ids = service.favoriteBookIDsPublisher.dropFirst().values.makeAsyncIterator()

        service.removeFromFavoriteBook(withID: id)
        await #expect(ids.next()?.isEmpty == true, "Unexpected data received.")
    }

}
