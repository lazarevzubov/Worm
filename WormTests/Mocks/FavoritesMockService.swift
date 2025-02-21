//
//  FavoritesMockService.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 6.4.2024.
//

import Combine
@testable
import Worm

actor FavoritesMockService: FavoritesService {

    // MARK: - Properties

    // MARK: FavoritesService protocol properties

    var blockedBookIDsPublisher: Published<Set<String>>.Publisher { $blockedBookIDs }
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { $favoriteBookIDs }
    @Published
    private(set) var blockedBookIDs = Set<String>()
    @Published
    private(set) var favoriteBookIDs: Set<String>

    // MARK: - Initialization

    init(favoriteBookIDs: Set<String> = []) async {
        self.favoriteBookIDs = favoriteBookIDs
    }

    // MARK: - Methods

    // MARK: FavoritesService protocol methods

    func addToBlockedBook(withID id: String) {
        blockedBookIDs.insert(id)
    }

    func addToFavoritesBook(withID id: String) {
        favoriteBookIDs.insert(id)
    }

    func removeFromFavoriteBook(withID id: String) {
        favoriteBookIDs.remove(id)
    }

}
