//
//  FavoritesModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 11.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import GoodreadsService

/// Owns logic of maintaining a list of favorite books.
protocol FavoritesModel: Actor {

    // MARK: - Properties

    /// The list of favorite books.
    var favorites: [Book] { get }
    /// The publisher of changes to the list of favorite books.
    var favoritesPublisher: Published<[Book]>.Publisher { get }

    // MARK: - Methods

    /// Toggles the favorite-ness state of a book.
    /// - Parameter bookID: The ID of the book to manipulate.
    func toggleFavoriteStateOfBook(withID id: String) async
    
}

// MARK: -

/// The default logic of the favorites list maintenance.
actor FavoritesServiceBasedModel: FavoritesModel {

    // MARK: - Properties

    // MARK: FavoritesModel protocol properties

    var favoritesPublisher: Published<[Book]>.Publisher { $favorites }
    @Published
    private(set) var favorites = [Book]()

    // MARK: Private properties

    private let catalogService: CatalogService
    private let favoritesService: any FavoritesService
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Creates a favorite books list handler.
    /// - Parameters:
    ///   - catalogService: The data service of the app.
    ///   - favoritesService: The favorite books list manager.
    init(catalogService: CatalogService, favoritesService: any FavoritesService) {
        self.catalogService = catalogService
        self.favoritesService = favoritesService

        Task { [weak self] in
            await self?.bind(favoritesService: favoritesService)
        }
    }

    // MARK: - Methods

    // MARK: FavoritesModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) async {
        if favorites.contains(where: { $0.id == id }) {
            await favoritesService.removeFromFavoriteBook(withID: id)
        } else {
            await favoritesService.addToFavoritesBook(withID: id)
        }
    }

    // MARK: Private methods

    private func bind(favoritesService: any FavoritesService) async {
        await favoritesService
            .favoriteBookIDsPublisher
            .removeDuplicates()
            .sink { @Sendable ids in
                Task { [weak self] in
                    await self?.updateFavorites(with: ids)
                }
            }
            .store(in: &cancellables)
    }

    private func updateFavorites(with favoriteBookIDs: Set<String>) async {
        favorites.removeAll { !favoriteBookIDs.contains($0.id) }
        for bookID in favoriteBookIDs {
            if let book = await catalogService.getBook(by: bookID),
               !favorites.contains(where: { $0.id == book.id }) {
                favorites.append(book)
            }
        }
    }

}
