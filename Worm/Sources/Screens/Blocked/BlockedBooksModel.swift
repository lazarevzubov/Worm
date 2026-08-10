//
//  BlockedBooksModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.8.2026.
//  Copyright © 2026 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

/// Owns logic of maintaining a list of blocked books.
protocol BlockedBooksModel: Actor {

    // MARK: - Properties

    /// The list of blocked books.
    var blockedBooks: [Book] { get }
    /// The publisher of changes to the list of blocked books.
    var blockedBooksPublisher: Published<[Book]>.Publisher { get }

    // MARK: - Methods

    /// Removes a book from the blocked list.
    /// - Parameter id: The ID of the book to manipulate.
    /// - Throws: An error if the change couldn't be persisted.
    func unblockBook(withID id: String) async throws

}

// MARK: -

/// The default logic of the blocked books list maintenance.
actor BlockedBooksServiceBasedModel: BlockedBooksModel {

    // MARK: - Properties

    // MARK: BlockedBooksModel protocol properties

    var blockedBooksPublisher: Published<[Book]>.Publisher { $blockedBooks }
    @Published
    private(set) var blockedBooks = [Book]()

    // MARK: Private properties

    private let blockedBooksService: any BlockedBooksService
    private let catalogService: CatalogService
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Creates a blocked books list handler.
    /// - Parameters:
    ///   - catalogService: The data service of the app.
    ///   - blockedBooksService: The blocked books list manager.
    init(catalogService: CatalogService, blockedBooksService: any BlockedBooksService) {
        self.catalogService = catalogService
        self.blockedBooksService = blockedBooksService

        Task { [weak self] in
            await self?.bindBlockedBooksService(blockedBooksService)
        }
    }

    // MARK: - Methods

    // MARK: BlockedBooksModel protocol methods

    func unblockBook(withID id: String) async throws {
        try await blockedBooksService.removeFromBlockedBook(withID: id)
    }

    // MARK: Private methods

    private func bindBlockedBooksService(_ blockedBooksService: any BlockedBooksService) async {
        await blockedBooksService
            .blockedBookIDsPublisher
            .removeDuplicates()
            .sink { @Sendable ids in
                Task { [weak self] in
                    await self?.updateBlocked(with: ids)
                }
            }
            .store(in: &cancellables)
    }

    private func updateBlocked(with blockedBookIDs: Set<String>) async {
        blockedBooks.removeAll { !blockedBookIDs.contains($0.id) }
        for bookID in blockedBookIDs {
            if let book = await catalogService.getBook(by: bookID),
               !blockedBooks.contains(where: { $0.id == book.id }) {
                blockedBooks.append(book)
            }
        }
    }

}
