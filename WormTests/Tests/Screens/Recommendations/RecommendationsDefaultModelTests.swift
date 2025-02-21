//
//  RecommendationsDefaultModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 6.4.2024.
//

import Combine
import GoodreadsService
import Testing
@testable
import Worm

struct RecommendationsDefaultModelTests {

    // MARK: - Methods

    @Test
    func favoriteBookIDs_empty_initially() async {
        let model = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService()
        )
        await #expect(model.favoriteBookIDs.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_updates() async {
        let id = "1"
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService(favoriteBookIDs: [id])
        )

        var ids =  await model.favoriteBookIDsPublisher.dropFirst().values.makeAsyncIterator()
        await #expect(ids.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_updates_onAddingFavorite() async {
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService()
        )

        var favorites = await model.favoriteBookIDsPublisher.dropFirst().values.makeAsyncIterator()

        let id = "1"
        await model.toggleFavoriteStateOfBook(withID: id)

        await #expect(favorites.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_updates_onRemovingFavorite() async {
        let id = "1"
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService(favoriteBookIDs: [id])
        )

        var favorites = await model.favoriteBookIDsPublisher.dropFirst().values.makeAsyncIterator()
        await #expect(favorites.next()?.isEmpty == false, "Unexpected data received.")

        await model.toggleFavoriteStateOfBook(withID: id)
        await #expect(favorites.next()?.isEmpty == true, "Unexpected data received.")
    }

    @Test
    func recommendations_empty_initially() async {
        let model = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(), favoritesService: FavoritesMockService()
        )
        await #expect(model.recommendations.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_received() async {
        let book = Book(
            id: "1",
            authors: ["J.R.R. Tolkien"],
            title: "The Lord of the Rings",
            description: "Desc1",
            similarBookIDs: ["15"]
        )
        let recommendedBook = Book(
            id: "15",
            authors: ["Haruki Murakami"],
            title: "The Wind-Up Bird Chronicle",
            description: "Desc2",
            similarBookIDs: ["1"]
        )

        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    book,
                    recommendedBook
                ]
            ),
            favoritesService: FavoritesMockService(favoriteBookIDs: ["1"])
        )

        var books = await model.recommendationsPublisher.dropFirst().values.makeAsyncIterator()
        await #expect(books.next() == [recommendedBook], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_received_onAddingFavorite() async {
        let book = Book(
            id: "1",
            authors: ["J.R.R. Tolkien"],
            title: "The Lord of the Rings",
            description: "Desc1",
            similarBookIDs: ["15"]
        )
        let recommendedBook = Book(
            id: "15",
            authors: ["Haruki Murakami"],
            title: "The Wind-Up Bird Chronicle",
            description: "Desc2",
            similarBookIDs: ["1"]
        )

        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    book,
                    recommendedBook
                ]
            ),
            favoritesService: FavoritesMockService()
        )

        var books = await model.recommendationsPublisher.dropFirst().values.makeAsyncIterator()

        await model.toggleFavoriteStateOfBook(withID: "1")
        await #expect(books.next() == [recommendedBook], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_received_onRemovingFavorite() async {
        let book = Book(
            id: "1",
            authors: ["J.R.R. Tolkien"],
            title: "The Lord of the Rings",
            description: "Desc1",
            similarBookIDs: ["15"]
        )
        let recommendedBook = Book(
            id: "15",
            authors: ["Haruki Murakami"],
            title: "The Wind-Up Bird Chronicle",
            description: "Desc2",
            similarBookIDs: ["1"]
        )

        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    book,
                    recommendedBook
                ]
            ),
            favoritesService: FavoritesMockService(favoriteBookIDs: [book.id])
        )

        var books = await model.recommendationsPublisher.dropFirst(2).values.makeAsyncIterator()
        try? await Task.sleep(for: .seconds(1)) // Imitates a separate update, after initialization.

        await model.toggleFavoriteStateOfBook(withID: book.id)
        await #expect(books.next()?.isEmpty == true, "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_received_onBlockingRecommendation() async {
        let book = Book(
            id: "1",
            authors: ["J.R.R. Tolkien"],
            title: "The Lord of the Rings",
            description: "Desc1",
            similarBookIDs: ["15"]
        )
        let recommendedBook = Book(
            id: "15",
            authors: ["Haruki Murakami"],
            title: "The Wind-Up Bird Chronicle",
            description: "Desc2",
            similarBookIDs: ["1"]
        )

        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    book,
                    recommendedBook
                ]
            ),
            favoritesService: FavoritesMockService(favoriteBookIDs: [book.id])
        )

        var books = await model.recommendationsPublisher.dropFirst().values.makeAsyncIterator()

        await model.blockFromRecommendationsBook(withID: recommendedBook.id)
        await #expect(books.next()?.isEmpty == true, "Unexpected data received.")
    }

    @Test
    func blockingRecommendation_updatesBlockedBooks() async {
        let favoritesService = await FavoritesMockService()
        let model: RecommendationsModel = RecommendationsDefaultModel(
            catalogService: CatalogMockService(), favoritesService: favoritesService
        )

        let id = "1"
        await model.blockFromRecommendationsBook(withID: id)

        await #expect(favoritesService.blockedBookIDs.contains(id))
    }

}
