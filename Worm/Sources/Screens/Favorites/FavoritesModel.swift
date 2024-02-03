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
protocol FavoritesModel: ObservableObject {

    // MARK: - Properties

    /// The list of favorite book.
    var favorites: [Book] { get }

    // MARK: - Methods

    /// Toggles the favorite-ness state of a book.
    /// - Parameter bookID: The ID of the book to manipulate.
    func toggleFavoriteStateOfBook(withID id: String)
    
}

// MARK: -

/// The default logic of the favorites list maintenance.
final class FavoritesServiceBasedModel<FavoriteBooksService: FavoritesService>: FavoritesModel {

    // MARK: - Properties

    // MARK: FavoritesModel protocol properties

    @Published
    var favorites = [Book]()

    // MARK: Private properties

    private let catalogService: CatalogService
    private let favoritesService: FavoriteBooksService
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
        updateFavorites()
    }

    // MARK: - Methods

    // MARK: FavoritesModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        if favorites.contains(where: { $0.id == id }) {
            favorites.removeAll { $0.id == id }
            favoritesService.removeFromFavoriteBook(withID: id)
        } else {
            favoritesService.addToFavoritesBook(withID: id)
        }
    }

    // MARK: Private methods

    private func bind(favoritesService: FavoriteBooksService) {
        favoritesService
            .objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.updateFavorites()
            }
            .store(in: &cancellables)
    }

    private func updateFavorites() {
        favoritesService.favoriteBooks.forEach { book in
            Task {
                if let book = await catalogService.getBook(by: book.id),
                   favorites.contains(where: { $0.id == book.id }) != true {
                    await MainActor.run { favorites.append(book) }
                }
            }
        }
    }

}
