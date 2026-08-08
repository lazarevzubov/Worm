//
//  BlockedBooksService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 7.8.2026.
//  Copyright © 2026 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation
import SwiftData

/// Manages a list of books blocked from recommendations.
protocol BlockedBooksService: Actor {

    // MARK: - Properties

    /// The list of IDs of books blocked from recommendations.
    var blockedBookIDs: Set<String> { get }
    /// The publisher of changes to the list of IDs of books blocked from recommendations.
    var blockedBookIDsPublisher: Published<Set<String>>.Publisher { get }

    // MARK: - Methods

    /// Blocks a book from recommendations.
    /// - Parameter id: The ID of the book to block.
    /// - Throws: An error if the change couldn't be persisted.
    func addToBlockedBook(withID id: String) throws
    /// Removes a book from the blocked list.
    /// - Parameter id: The ID of the book to be removed.
    /// - Throws: An error if the change couldn't be persisted.
    func removeFromBlockedBook(withID id: String) throws

}

// MARK: -

/// The blocked books service based on a Swift Data persistent storage.
actor BlockedBooksPersistenceService: BlockedBooksService {

    // MARK: - Properties

    // MARK: BlockedBooksService protocol properties

    var blockedBookIDsPublisher: Published<Set<String>>.Publisher { $blockedBookIDs }
    @Published
    private(set) var blockedBookIDs = Set<String>()

    // MARK: Private properties

    private let container: ModelContainer
    private var blockedBooks: [BlockedBook] {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<BlockedBook>()

        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - Initialization

    /// Creates a service instance.
    /// - Parameter modelContainer: An object that manages an app’s schema and model storage configuration.
    init(modelContainer: ModelContainer) {
        container = modelContainer
        Task { [weak self] in
            await self?.updateBlockedBooks()
        }
    }

    // MARK: - Methods

    // MARK: BlockedBooksService protocol methods

    func addToBlockedBook(withID id: String) throws {
        let blockedBook = BlockedBook(id: id)

        let context = ModelContext(container)
        context.insert(blockedBook)

        try context.save()

        updateBlockedBooks()
    }

    func removeFromBlockedBook(withID id: String) throws {
        let context = ModelContext(container)
        try context.delete(model: BlockedBook.self, where: #Predicate { $0.id == id })
        try context.save()

        updateBlockedBooks()
    }

    // MARK: Private methods

    private func updateBlockedBooks() {
        blockedBookIDs = Set(blockedBooks.map { $0.id })
    }

}
