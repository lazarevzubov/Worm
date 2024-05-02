//
//  FavoritesModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 11.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Dispatch
import GoodreadsService

/// Owns logic of maintaining a list of favorite books.
protocol FavoritesModel: Sendable, AnyObject {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var favorites: [Book] { get }
    // TODO: HeaderDoc.
    var favoritesPublisher: Published<[Book]>.Publisher { get }

    // MARK: - Methods

    /// Toggles the favorite-ness state of a book.
    /// - Parameter bookID: The ID of the book to manipulate.
    func toggleFavoriteStateOfBook(withID id: String)
    
}

// MARK: -

/// The default logic of the favorites list maintenance.
final class FavoritesServiceBasedModel<FavoriteBooksService: FavoritesService>: @unchecked Sendable, FavoritesModel {

    // MARK: - Properties

    // MARK: FavoritesModel protocol properties

    var favoritesPublisher: Published<[Book]>.Publisher { $favorites }
    @Published
    private(set) var favorites = [Book]()

    // MARK: Private properties

    private let catalogService: CatalogService
    private let favoritesService: FavoriteBooksService
    private let synchronizationQueue = DispatchQueue(label: "com.lazarevzubov.FavoritesServiceBasedModel")
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Creates a favorite books list handler.
    /// - Parameters:
    ///   - catalogService: The data service of the app.
    ///   - favoritesService: The favorite books list manager.
    init(catalogService: CatalogService, favoritesService: FavoriteBooksService) {
        self.catalogService = catalogService
        self.favoritesService = favoritesService

        bind(favoritesService: self.favoritesService)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Methods

    // MARK: FavoritesModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        if favorites.contains(where: { $0.id == id }) {
            favoritesService.removeFromFavoriteBook(withID: id)
        } else {
            favoritesService.addToFavoritesBook(withID: id)
        }
    }

    // MARK: Private methods

    private func bind(favoritesService: FavoriteBooksService) {
        favoritesService
            .favoriteBookIDsPublisher
            .removeDuplicates()
            .sink { id in
                Task { [weak self] in
                    await self?.updateFavorites(with: id)
                }
            }
            .store(in: &cancellables)
    }

    private func updateFavorites(with favoriteBookIDs: Set<String>) async {
        for bookID in favoriteBookIDs {
            if let book = await catalogService.getBook(by: bookID),
               !favorites.contains(where: { $0.id == book.id }) {
                synchronizationQueue.sync { favorites.append(book) }
            }
        }
        synchronizationQueue.sync {
            favorites.removeAll { !favoriteBookIDs.contains($0.id) }
        }
    }

}
