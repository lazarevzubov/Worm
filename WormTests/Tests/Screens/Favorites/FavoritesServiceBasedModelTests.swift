//
//  FavoritesServiceBasedModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 21.3.2024.
//

import Combine
import GoodreadsService
import Testing
@testable
import Worm

struct FavoritesServiceBasedModelTests {

    // MARK: - Methods

    @Test
    func favorites_empty_initially() async {
        let model: FavoritesModel = await FavoritesServiceBasedModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService()
        )
        await #expect(model.favorites.isEmpty, "Favorites are not empty initially.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favorites_update() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let catalogService = CatalogMockService(books: [book])
        let favoritesService = await FavoritesMockService(favoriteBookIDs: [id])

        let model: FavoritesModel = FavoritesServiceBasedModel(
            catalogService: catalogService, favoritesService: favoritesService
        )

        var favorites = await model.favoritesPublisher.dropFirst().values.makeAsyncIterator()
        await #expect(favorites.next() == [book], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favorites_update_onAddingFavorite() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let catalogService = CatalogMockService(books: [book])
        let model: FavoritesModel = await FavoritesServiceBasedModel(
            catalogService: catalogService, favoritesService: FavoritesMockService()
        )

        var favorites = await model.favoritesPublisher.removeDuplicates().dropFirst().values.makeAsyncIterator()

        await model.toggleFavoriteStateOfBook(withID: id)
        await #expect(favorites.next() == [book], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favorites_update_onRemovingFavorite() async {
        let id = "1"
        let book = Book(id: id, authors: [], title: "", description: "Desc")

        let catalogService = CatalogMockService(books: [book])
        let favoritesService = await FavoritesMockService(favoriteBookIDs: [id])

        let model: FavoritesModel = FavoritesServiceBasedModel(
            catalogService: catalogService, favoritesService: favoritesService
        )

        await model.toggleFavoriteStateOfBook(withID: id)
        while await !model.favorites.isEmpty {
            await Task.yield()
        }
    }

}
