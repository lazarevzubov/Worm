//
//  BlockedBooksServiceBasedModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 9.8.2026.
//

import Combine
import GoodreadsService
import Testing
@testable
import Worm

struct BlockedBooksServiceBasedModelTests {

    // MARK: - Methods

    @Test
    func blocked_empty_initially() async {
        let model: BlockedBooksModel = await BlockedBooksServiceBasedModel(
            catalogService: CatalogMockService(), blockedBooksService: BlockedBooksMockService()
        )
        await #expect(model.blockedBooks.isEmpty, "Blocked list is not empty initially.")
    }

    @Test(.timeLimit(.minutes(1)))
    func blocked_update() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let model: BlockedBooksModel = await BlockedBooksServiceBasedModel(
            catalogService: CatalogMockService(books: [book]),
            blockedBooksService: BlockedBooksMockService(blockedBookIDs: [id])
        )
        while await model.blockedBooks != [book] {
            await Task.yield()
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func blocked_update_onUnblocking() async throws {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let model: BlockedBooksModel = await BlockedBooksServiceBasedModel(
            catalogService: CatalogMockService(books: [book]),
            blockedBooksService: BlockedBooksMockService(blockedBookIDs: [id])
        )
        while await model.blockedBooks != [book] {
            await Task.yield()
        }

        try await model.unblockBook(withID: id)
        while await !model.blockedBooks.isEmpty {
            await Task.yield()
        }
    }

    @Test
    func unblockBook_throws_whenServiceFails() async {
        let model: BlockedBooksModel = await BlockedBooksServiceBasedModel(
            catalogService: CatalogMockService(),
            blockedBooksService: BlockedBooksMockService(errorToThrow: MockError())
        )
        await #expect(throws: MockError.self) { try await model.unblockBook(withID: "1") }
    }

}
