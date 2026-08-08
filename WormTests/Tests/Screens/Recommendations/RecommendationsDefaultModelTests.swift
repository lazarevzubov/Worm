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
            catalogService: CatalogMockService(),
            favoritesService: FavoritesMockService(),
            blockedBooksService: BlockedBooksMockService()
        )
        await #expect(model.favoriteBookIDs.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_updates() async {
        let id = "1"
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(),
            favoritesService: FavoritesMockService(favoriteBookIDs: [id]),
            blockedBooksService: BlockedBooksMockService()
        )

        var ids =  await model.favoriteBookIDsPublisher.dropFirst().values.makeAsyncIterator()
        await #expect(ids.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_updates_onAddingFavorite() async throws {
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(),
            favoritesService: FavoritesMockService(),
            blockedBooksService: BlockedBooksMockService()
        )

        var favorites = await model.favoriteBookIDsPublisher.dropFirst().values.makeAsyncIterator()

        let id = "1"
        try await model.toggleFavoriteStateOfBook(withID: id)

        await #expect(favorites.next() == [id], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func favoriteBookIDs_updates_onRemovingFavorite() async throws {
        let id = "1"
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(),
            favoritesService: FavoritesMockService(favoriteBookIDs: [id]),
            blockedBooksService: BlockedBooksMockService()
        )

        var favorites = await model.favoriteBookIDsPublisher.dropFirst().values.makeAsyncIterator()
        await #expect(favorites.next()?.isEmpty == false, "Unexpected data received.")

        try await model.toggleFavoriteStateOfBook(withID: id)
        await #expect(favorites.next()?.isEmpty == true, "Unexpected data received.")
    }

    @Test
    func recommendations_empty_initially() async {
        let model = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(),
            favoritesService: FavoritesMockService(),
            blockedBooksService: BlockedBooksMockService()
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
            favoritesService: FavoritesMockService(favoriteBookIDs: ["1"]),
            blockedBooksService: BlockedBooksMockService()
        )

        var books = await model.recommendationsPublisher.dropFirst().values.makeAsyncIterator()
        await #expect(books.next() == [recommendedBook], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_received_onAddingFavorite() async throws {
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
            favoritesService: FavoritesMockService(),
            blockedBooksService: BlockedBooksMockService()
        )

        var books = await model.recommendationsPublisher.dropFirst().values.makeAsyncIterator()

        try await model.toggleFavoriteStateOfBook(withID: "1")
        await #expect(books.next() == [recommendedBook], "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_received_onRemovingFavorite() async throws {
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
            favoritesService: FavoritesMockService(favoriteBookIDs: [book.id]),
            blockedBooksService: BlockedBooksMockService()
        )

        var books = await model.recommendationsPublisher.dropFirst(2).values.makeAsyncIterator()
        try? await Task.sleep(for: .seconds(1)) // Imitates a separate update, after initialization.

        try await model.toggleFavoriteStateOfBook(withID: book.id)
        await #expect(books.next()?.isEmpty == true, "Unexpected data received.")
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_keepsBook_whenOnlyOneOfMultipleSourcesIsRemoved() async throws {
        let firstFavorite = Book(
            id: "1", authors: ["Author"], title: "First Favorite", description: "Desc1", similarBookIDs: ["100"]
        )
        let secondFavorite = Book(
            id: "2", authors: ["Author"], title: "Second Favorite", description: "Desc2", similarBookIDs: ["100"]
        )

        let recommendedBook = Book(
            id: "100", authors: ["Author"], title: "Recommended", description: "Desc3", similarBookIDs: []
        )

        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    firstFavorite,
                    secondFavorite,
                    recommendedBook
                ]
            ),
            favoritesService: FavoritesMockService(
                favoriteBookIDs: [
                    firstFavorite.id,
                    secondFavorite.id
                ]
            ),
            blockedBooksService: BlockedBooksMockService()
        )

        var books = await model.recommendationsPublisher.dropFirst().values.makeAsyncIterator()
        await #expect(books.next() == [recommendedBook], "Unexpected data received.")

        try? await Task.sleep(for: .seconds(1)) // Lets both favorite sources finish adding the recommendation.

        try await model.toggleFavoriteStateOfBook(withID: secondFavorite.id)
        await #expect(
            books.next() == [recommendedBook],
            "The book should stay recommended while the other favorite still recommends it."
        )
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_received_onBlockingRecommendation() async throws {
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
            favoritesService: FavoritesMockService(favoriteBookIDs: [book.id]),
            blockedBooksService: BlockedBooksMockService()
        )

        var books = await model.recommendationsPublisher.dropFirst().values.makeAsyncIterator()

        try await model.blockFromRecommendationsBook(withID: recommendedBook.id)
        await #expect(books.next()?.isEmpty == true, "Unexpected data received.")
    }

    @Test
    func blockingRecommendation_updatesBlockedBooks() async throws {
        let blockedBooksService = await BlockedBooksMockService()
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(),
            favoritesService: FavoritesMockService(),
            blockedBooksService: blockedBooksService
        )

        let id = "1"
        try await model.blockFromRecommendationsBook(withID: id)

        await #expect(blockedBooksService.blockedBookIDs.contains(id))
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_ordersBooks_byNumberOfRecommendingFavorites() async {
        let firstFavorite = Book(
            id: "1",
            authors: ["Author"],
            title: "First Favorite",
            description: "Desc1",
            similarBookIDs: [
                "100",
                "200"
            ]
        )
        let secondFavorite = Book(
            id: "2", authors: ["Author"], title: "Second Favorite", description: "Desc2", similarBookIDs: ["100"]
        )

        let higherRanked = Book(id: "100", authors: ["Author"], title: "Higher Ranked", description: "Desc3")
        let lowerRanked = Book(id: "200", authors: ["Author"], title: "Lower Ranked", description: "Desc4")

        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    firstFavorite,
                    secondFavorite,
                    higherRanked,
                    lowerRanked
                ]
            ),
            favoritesService: FavoritesMockService(
                favoriteBookIDs: [
                    firstFavorite.id,
                    secondFavorite.id
                ]
            ),
            blockedBooksService: BlockedBooksMockService()
        )

        while await model.recommendations != [
            higherRanked,
            lowerRanked
        ] {
            await Task.yield()
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_lowersRank_ofBooksRecommendedByBlockedBook() async throws {
        let favorite = Book(
            id: "1",
            authors: ["Author"],
            title: "Favorite",
            description: "Desc1",
            similarBookIDs: [
                "100",
                "200",
                "300"
            ]
        )
        let blockedRecommendation = Book(
            id: "100", authors: ["Author"], title: "Blocked", description: "Desc2", similarBookIDs: ["200"]
        )

        let penalizedRecommendation = Book(id: "200", authors: ["Author"], title: "Penalized", description: "Desc3")
        let unaffectedRecommendation = Book(id: "300", authors: ["Author"], title: "Unaffected", description: "Desc4")

        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    favorite,
                    blockedRecommendation,
                    penalizedRecommendation,
                    unaffectedRecommendation
                ]
            ),
            favoritesService: FavoritesMockService(favoriteBookIDs: [favorite.id]),
            blockedBooksService: BlockedBooksMockService()
        )

        while await model.recommendations != [
            blockedRecommendation,
            penalizedRecommendation,
            unaffectedRecommendation
        ] {
            await Task.yield()
        }

        try await model.blockFromRecommendationsBook(withID: blockedRecommendation.id)
        while await model.recommendations != [
            unaffectedRecommendation,
            penalizedRecommendation
        ] {
            await Task.yield()
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_reversesRankPenalty_andReintroducesBook_onUnblocking() async throws {
        let favorite = Book(
            id: "1",
            authors: ["Author"],
            title: "Favorite",
            description: "Desc1",
            similarBookIDs: [
                "100",
                "200",
                "300"
            ]
        )
        let blockedRecommendation = Book(
            id: "100", authors: ["Author"], title: "Blocked", description: "Desc2", similarBookIDs: ["200"]
        )

        let penalizedRecommendation = Book(id: "200", authors: ["Author"], title: "Penalized", description: "Desc3")
        let unaffectedRecommendation = Book(id: "300", authors: ["Author"], title: "Unaffected", description: "Desc4")

        let blockedBooksService = await BlockedBooksMockService()
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    favorite,
                    blockedRecommendation,
                    penalizedRecommendation,
                    unaffectedRecommendation
                ]
            ),
            favoritesService: FavoritesMockService(favoriteBookIDs: [favorite.id]),
            blockedBooksService: blockedBooksService
        )

        while await model.recommendations != [
            blockedRecommendation,
            penalizedRecommendation,
            unaffectedRecommendation
        ] {
            await Task.yield()
        }

        try await model.blockFromRecommendationsBook(withID: blockedRecommendation.id)
        while await model.recommendations != [
            unaffectedRecommendation,
            penalizedRecommendation
        ] {
            await Task.yield()
        }

        try await blockedBooksService.removeFromBlockedBook(withID: blockedRecommendation.id)
        while await Set(model.recommendations) != [
            blockedRecommendation,
            penalizedRecommendation,
            unaffectedRecommendation
        ] {
            await Task.yield()
        }
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsUpdate_appliesAlreadyBlockedBooksPenalty_toNewlyAddedRecommendation() async {
        let alreadyBlocked = Book(
            id: "1", authors: ["Author"], title: "Already Blocked", description: "Desc1", similarBookIDs: ["200"]
        )
        let favorite = Book(
            id: "2",
            authors: ["Author"],
            title: "Favorite",
            description: "Desc2",
            similarBookIDs: [
                "200",
                "300"
            ]
        )

        let penalizedRecommendation = Book(id: "200", authors: ["Author"], title: "Penalized", description: "Desc3")
        let unaffectedRecommendation = Book(id: "300", authors: ["Author"], title: "Unaffected", description: "Desc4")

        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(
                books: [
                    alreadyBlocked,
                    favorite,
                    penalizedRecommendation,
                    unaffectedRecommendation
                ]
            ),
            favoritesService: FavoritesMockService(favoriteBookIDs: [favorite.id]),
            blockedBooksService: BlockedBooksMockService(blockedBookIDs: [alreadyBlocked.id])
        )

        while await model.recommendations != [
            unaffectedRecommendation,
            penalizedRecommendation
        ] {
            await Task.yield()
        }
    }

    @Test
    func toggleFavoriteStateOfBook_throws_whenServiceFails() async {
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(),
            favoritesService: FavoritesMockService(errorToThrow: MockError()),
            blockedBooksService: BlockedBooksMockService()
        )
        await #expect(throws: MockError.self) { try await model.toggleFavoriteStateOfBook(withID: "1") }
    }

    @Test
    func blockFromRecommendationsBook_throws_whenServiceFails() async {
        let model: RecommendationsModel = await RecommendationsDefaultModel(
            catalogService: CatalogMockService(),
            favoritesService: FavoritesMockService(),
            blockedBooksService: BlockedBooksMockService(errorToThrow: MockError())
        )
        await #expect(throws: MockError.self) { try await model.blockFromRecommendationsBook(withID: "1") }
    }

}
