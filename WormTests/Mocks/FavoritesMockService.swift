//
//  FavoritesMockService.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 4.8.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

@testable
import Worm

final class MockFavoriteBook: FavoriteBook {

    // MARK: - Properties

    override var id: String {
        set {
            // Do nothing.
        }
        get { return mockID }
    }
    var mockID: String = ""

    // MARK: - Initialization

    convenience init(id: String) {
        self.init()
        self.mockID = id
    }

}

// MARK: -

final class MockBlockedBook: BlockedBook {

    // MARK: - Properties

    override var id: String {
        set {
            // Do nothing.
        }
        get { return mockID }
    }
    var mockID: String = ""

    // MARK: - Initialization

    convenience init(id: String) {
        self.init()
        self.mockID = id
    }

}

// MARK: -

final class FavoritesMockService: FavoritesService {

    // MARK: - Properties

    // MARK: FavoritesService protocol properties

    private(set) var blockedBooks: [BlockedBook] = []
    private(set) var favoriteBooks: [FavoriteBook] {
        didSet { objectWillChange.send() }
    }

    // MARK: - Initialization

    init(favoriteBooks: [FavoriteBook] = []) {
        self.favoriteBooks = favoriteBooks
        objectWillChange.send()
    }

    // MARK: - Methods

    // MARK: FavoritesService protocol methods

    func addToBlockedBook(withID id: String) {
        let blockedBook = MockBlockedBook(id: id)
        blockedBooks.append(blockedBook)
    }

    func addToFavoritesBook(withID id: String) {
        if !favoriteBooks.contains(where: { $0.id == id }) {
            let book = MockFavoriteBook(id: id)
            favoriteBooks.append(book)
        }
    }

    func removeFromFavoriteBook(withID id: String) {
        favoriteBooks.removeAll { $0.id == id }
    }

}
