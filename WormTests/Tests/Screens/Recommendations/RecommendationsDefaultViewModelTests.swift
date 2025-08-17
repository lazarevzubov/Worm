//
//  RecommendationsDefaultViewModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 7.4.2024.
//

import Combine
import GoodreadsService
import SwiftUI
import Testing
@testable
import Worm

struct RecommendationsDefaultViewModelTests {

    // MARK: - Methods

    @MainActor
    @Test
    func recommendationsOnboarding_stateInitially_asProvided() async {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)

        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(), onboardingService: service, imageService: ImageMockService()
        )
        #expect(vm.onboardingShown == value, "Onboarding has an unexpected initial value.")
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func recommendationsOnboarding_update_updatesPersistence() async {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)
        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(), onboardingService: service, imageService: ImageMockService()
        )

        let newValue = !value
        vm.onboardingShown = newValue

        while service.recommendationsOnboardingShown != newValue {
            await Task.yield()
        }
    }

    @MainActor
    @Test
    func recommendations_empty_initially() async {
        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        #expect(vm.recommendations.isEmpty)
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func recommendations_update() async {
        let recommendations: Set = [Book(id: "1", authors: [], title: "", description: "Desc")]
        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(recommendations: recommendations),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        while vm.recommendations != [
            BookViewModel(book: Book(id: "1", authors: [], title: "", description: "Desc"), favorite: false)
        ] {
            await Task.yield()
        }
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func recommendations_update_afterTogglingFavorite() async {
        let id = "1"
        let recommendations: Set = [Book(id: id, authors: [], title: "", description: "Desc")]
        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(recommendations: recommendations),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        vm.toggleFavoriteStateOfBook(withID: id)
        while !vm.recommendations.isEmpty {
            await Task.yield()
        }
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func togglingFavorite_updatesModel() async {
        let model = await RecommendationsMockModel()
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: model,
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        let id = "1"
        vm.toggleFavoriteStateOfBook(withID: id)

        while await !model.favoriteBookIDs.contains(id) {
            await Task.yield()
        }
    }

    @MainActor
    @Test
    func detailsViewModel_authors_accordingToBook() async {
        let authors = [
            "Author 1",
            "Authors 2"
        ]
        let bookVM = BookViewModel(
            book: Book(id: "1", authors: authors, title: "Title", description: "Desc"),
            favorite: false
        )

        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        let detailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(detailsVM.authors == "Author 1, Authors 2", "Unexpected authors string")
    }

    @MainActor
    @Test
    func detailsViewModel_title_accordingToBook() async {
        let title = "Title"
        let bookVM = BookViewModel(
            book: Book(
                id: "1",
                authors: [
                    "Author 1",
                    "Authors 2"
                ],
                title: title,
                description: "Desc"
            ),
            favorite: false
        )

        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        let detailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(detailsVM.title == "Title", "Unexpected title string")
    }

    @MainActor
    @Test
    func detailsViewModel_createsRatingViewModel_withRating_accordingToBook() async {
        let bookVM = BookViewModel(
            book: Book(
                id: "1",
                authors: [
                    "Author 1",
                    "Authors 2"
                ],
                title: "Title",
                description: "Desc",
                rating: 1.23
            ),
            favorite: false
        )

        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        let detailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(detailsVM.ratingViewModel?.rating == 1.23, "Unexpected rating string")
    }

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func blockingRecommendation_updatesModel() async {
        let model = await RecommendationsMockModel()
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: model,
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        let id = "1"
        let bookVM = BookViewModel(book: Book(id: id, authors: [], title: "", description: "Desc2"), favorite: false)

        vm.blockRecommendation(bookVM)
        while await !model.blockedRecommendations.contains(id) {
            await Task.yield()
        }
    }

    @MainActor
    @Test
    func appliedFilters_empty_initially() async {
        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        #expect(vm.appliedFilters.isEmpty)
    }

    @MainActor
    @Test
    func recommendations_update_whenAppliedFilters_change() async {
        let book = Book(id: "1", authors: [], title: "", description: "Desc", rating: 3.0)
        let recommendations: Set = [book]

        let vm: any RecommendationsViewModel = await RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(recommendations: recommendations),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        while vm.recommendations != [BookViewModel(book: book, favorite: false)] {
            await Task.yield()
        }

        vm.appliedFilters.append(.topRated)
        while !vm.recommendations.isEmpty {
            await Task.yield()
        }
    }

    // MARK: -

    private actor RecommendationsMockModel: RecommendationsModel {

        // MARK: - Properties

        private(set) var blockedRecommendations = Set<String>()

        // MARK: RecommendationsModel protocol properties

        var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { $favoriteBookIDs }
        var recommendationsPublisher: Published<Set<Book>>.Publisher { $recommendations }
        @Published
        private(set) var favoriteBookIDs: Set<String>
        @Published
        private(set) var recommendations: Set<Book>

        // MARK: - Initialization

        init(recommendations: Set<Book> = [], favoriteBookIDs: Set<String> = []) async {
            self.recommendations = recommendations
            self.favoriteBookIDs = favoriteBookIDs
        }

        // MARK: - Methods

        func toggleFavoriteStateOfBook(withID id: String) {
            if favoriteBookIDs.contains(id) {
                favoriteBookIDs.remove(id)
            } else {
                favoriteBookIDs.insert(id)
            }
        }

        func blockFromRecommendationsBook(withID id: String) {
            blockedRecommendations.insert(id)
        }

    }

}
