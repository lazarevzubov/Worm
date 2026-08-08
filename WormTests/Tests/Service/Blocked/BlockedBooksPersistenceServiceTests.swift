//
//  BlockedBooksPersistenceServiceTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 7.8.2026.
//

import Combine
import SwiftData
import Testing
@testable
import Worm

struct BlockedBooksPersistenceServiceTests {

    // MARK: - Methods

    @Test
    func blockedBookIDs_empty_initially() async throws {
        let schema = Schema([BlockedBook.self], version: Schema.Version(1, 0, 0))
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = BlockedBooksPersistenceService(modelContainer: modelContainer)
        await #expect(service.blockedBookIDs.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func blockedBookIDs_update() async throws {
        let schema = Schema([BlockedBook.self], version: Schema.Version(1, 0, 0))
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let id = "ID"
        let blockedBook = BlockedBook(id: id)

        let context = ModelContext(modelContainer)
        context.insert(blockedBook)
        try context.save()

        let service = BlockedBooksPersistenceService(modelContainer: modelContainer)
        var ids = await service.blockedBookIDsPublisher.dropFirst().values.makeAsyncIterator()

        await #expect(ids.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func blockedBookIDs_update_onAdding() async throws {
        let schema = Schema([BlockedBook.self], version: Schema.Version(1, 0, 0))
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let service = BlockedBooksPersistenceService(modelContainer: modelContainer)
        var ids = await service.blockedBookIDsPublisher.dropFirst().values.makeAsyncIterator()

        let id = "ID"
        try await service.addToBlockedBook(withID: id)

        await #expect(ids.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func blockedBookIDs_update_onRemoving() async throws {
        let schema = Schema([BlockedBook.self], version: Schema.Version(1, 0, 0))
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

        let id = "ID"
        let blockedBook = BlockedBook(id: id)

        let context = ModelContext(modelContainer)
        context.insert(blockedBook)
        try context.save()

        let service = BlockedBooksPersistenceService(modelContainer: modelContainer)
        var ids = await service.blockedBookIDsPublisher.dropFirst().values.makeAsyncIterator()

        try await service.removeFromBlockedBook(withID: id)
        await #expect(ids.next()?.isEmpty == true, "Unexpected data received.")
    }

}
