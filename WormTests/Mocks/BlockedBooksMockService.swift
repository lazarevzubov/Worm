//
//  BlockedBooksMockService.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 7.8.2026.
//

import Combine
@testable
import Worm

actor BlockedBooksMockService: BlockedBooksService {

    // MARK: - Properties

    // MARK: BlockedBooksService protocol properties

    var blockedBookIDsPublisher: Published<Set<String>>.Publisher { $blockedBookIDs }
    @Published
    private(set) var blockedBookIDs: Set<String>

    // MARK: Private properties

    private let errorToThrow: Error?

    // MARK: - Initialization

    init(blockedBookIDs: Set<String> = [], errorToThrow: Error? = nil) async {
        self.blockedBookIDs = blockedBookIDs
        self.errorToThrow = errorToThrow
    }

    // MARK: - Methods

    // MARK: BlockedBooksService protocol methods

    func addToBlockedBook(withID id: String) throws {
        if let errorToThrow {
            throw errorToThrow
        }
        blockedBookIDs.insert(id)
    }

    func removeFromBlockedBook(withID id: String) throws {
        if let errorToThrow {
            throw errorToThrow
        }
        blockedBookIDs.remove(id)
    }

}
