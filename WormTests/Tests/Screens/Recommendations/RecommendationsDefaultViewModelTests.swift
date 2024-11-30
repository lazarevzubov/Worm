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

    @Test
    func recommendationsOnboarding_stateInitially_asProvided() {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)

        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(), onboardingService: service, imageService: ImageMockService()
        )
        #expect(vm.onboardingShown == value, "Onboarding has an unexpected initial value.")
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendationsOnboarding_update_updatesPersistence() async {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(), onboardingService: service, imageService: ImageMockService()
        )

        let newValue = !value
        vm.onboardingShown = newValue

        while service.recommendationsOnboardingShown != newValue {
            await Task.yield()
        }
    }

    @Test
    func recommendations_empty_initially() {
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        #expect(vm.recommendations.isEmpty)
    }

    @Test(.timeLimit(.minutes(1)))
    func recommendations_update() async {
        let recommendations: Set = [Book(id: "1", authors: [], title: "", description: "Desc")]
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
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

    @Test(.timeLimit(.minutes(1)))
    func recommendations_update_afterTogglingFavorite() async {
        let id = "1"
        let recommendations: Set = [Book(id: id, authors: [], title: "", description: "Desc")]
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(recommendations: recommendations),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        vm.toggleFavoriteStateOfBook(withID: id)
        while !vm.recommendations.isEmpty {
            await Task.yield()
        }
    }

    @Test
    func togglingFavorite_updatesModel() {
        let model = RecommendationsMockModel()
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: model,
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        let id = "1"
        vm.toggleFavoriteStateOfBook(withID: id)

        #expect(model.favoriteBookIDs.contains(id))
    }

    @Test
    func detailsViewModel_authors_accordingToBook() {
        let authors = [
            "Author 1",
            "Authors 2"
        ]
        let bookVM = BookViewModel(
            book: Book(id: "1", authors: authors, title: "Title", description: "Desc"),
            favorite: false
        )

        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        let detailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(detailsVM.authors == "Author 1, Authors 2", "Unexpected authors string")
    }

    @Test
    func detailsViewModel_title_accordingToBook() {
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

        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        let detailsVM = vm.makeDetailsViewModel(for: bookVM)

        #expect(detailsVM.title == "Title", "Unexpected title string")
    }

    @Test(.timeLimit(.minutes(1)))
    func detailsViewModel_image_accordingToImageService() async {
        let imageURL = URL(string: "https://apple.com")!
        let image = UniversalImage()
        let imageService = ImageMockService(images: [imageURL : image])

        let bookVM = BookViewModel(
            book: Book(
                id: "1",
                authors: [
                    "Author 1",
                    "Authors 2"
                ],
                title: "Title",
                description: "Desc",
                imageURL: imageURL
            ),
            favorite: false
        )

        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: imageService
        )
        let detailsVM = vm.makeDetailsViewModel(for: bookVM)

        while detailsVM.image != image {
            await Task.yield()
        }
    }

    @Test
    func blockingRecommendation_updatesModel() {
        let model = RecommendationsMockModel()
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: model,
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        let id = "1"
        let bookVM = BookViewModel(book: Book(id: id, authors: [], title: "", description: "Desc2"), favorite: false)

        vm.blockRecommendation(bookVM)
        #expect(model.blockedRecommendations.contains(id))
    }

    // MARK: -

    private final class RecommendationsMockModel: @unchecked Sendable, RecommendationsModel {

        // MARK: - Properties

        private(set) var blockedRecommendations = Set<String>()

        // MARK: RecommendationsModel protocol properties

        var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { $favoriteBookIDs }
        var recommendationsPublisher: Published<Set<Book>>.Publisher { $recommendations }
        @Published
        private(set) var favoriteBookIDs: Set<String>
        @Published
        private(set) var recommendations: Set<Book>

        // MARK: Private properties

        private let synchronizationQueue = DispatchQueue(label: "com.lazarevzubov.RecommendationsMockModel")

        // MARK: - Initialization

        init(recommendations: Set<Book> = [], favoriteBookIDs: Set<String> = []) {
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
            _ = synchronizationQueue.sync { blockedRecommendations.insert(id) }
        }

    }

}
