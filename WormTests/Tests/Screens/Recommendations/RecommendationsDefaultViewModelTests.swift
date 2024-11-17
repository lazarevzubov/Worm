//
//  RecommendationsDefaultViewModelTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 7.4.2024.
//

import Combine
import GoodreadsService
import SwiftUI
@testable
import Worm
import XCTest

final class RecommendationsDefaultViewModelTest: XCTestCase {

    // MARK: - Methods

    func testRecommendationsOnboarding_stateInitially_asProvided() {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)

        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(), onboardingService: service, imageService: ImageMockService()
        )
        XCTAssertEqual(vm.onboardingShown, value, "Onboarding has an unexpected initial value.")
    }

    func testRecommendationsOnboarding_update_updatesPersistence() {
        let value = true
        let service = OnboardingMockService(onboardingShown: value)
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(), onboardingService: service, imageService: ImageMockService()
        )

        let newValue = !value
        let predicate = NSPredicate { service, _ in
            guard let service = service as? OnboardingService else {
                return false
            }
            return service.recommendationsOnboardingShown == newValue
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: service)

        vm.onboardingShown = newValue
        wait(for: [expectation], timeout: 2.0)
    }

    func testRecommendations_initiallyEmpty() {
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )
        XCTAssertTrue(vm.recommendations.isEmpty)
    }

    func testRecommendations_update() {
        let recommendations: Set = [Book(id: "1", authors: [], title: "", description: "Desc")]
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(recommendations: recommendations),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any RecommendationsViewModel else {
                return false
            }
            return vm.recommendations == [
                BookViewModel(book: Book(
                    id: "1", authors: [], title: "", description: "Desc"
                ),
                              favorite: false)
            ]
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        wait(for: [expectation], timeout: 3.0)
    }

    func testRecommendations_update_afterTogglingFavorite() {
        let id = "1"
        let recommendations: Set = [Book(id: id, authors: [], title: "", description: "Desc")]
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(recommendations: recommendations),
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any RecommendationsViewModel else {
                return false
            }
            return vm.recommendations.isEmpty
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        vm.toggleFavoriteStateOfBook(withID: id)
        wait(for: [expectation], timeout: 2.0)
    }

    func testTogglingFavorite_updatesModel() {
        let model = RecommendationsMockModel()
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: model,
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        let id = "1"
        vm.toggleFavoriteStateOfBook(withID: id)

        XCTAssertTrue(model.favoriteBookIDs.contains(id))
    }

    func testDetailsViewModel_authors_accordingToBook() {
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

        XCTAssertEqual(detailsVM.authors, "Author 1, Authors 2", "Unexpected authors string")
    }

    func testDetailsViewModel_title_accordingToBook() {
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

        XCTAssertEqual(detailsVM.title, "Title", "Unexpected title string")
    }

    func testDetailsViewModel_image_accordingToImageService() {
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

        let predicate = NSPredicate { detailsVM, _ in
            guard let detailsVM = detailsVM as? any BookDetailsViewModel else {
                return false
            }
            return detailsVM.image == image
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: detailsVM)

        wait(for: [expectation], timeout: 2.0)
    }

    func testBlockingRecommendation_updatesModel() {
        let model = RecommendationsMockModel()
        let vm: any RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: model,
            onboardingService: OnboardingMockService(),
            imageService: ImageMockService()
        )

        let id = "1"
        let bookVM = BookViewModel(book: Book(id: id, authors: [], title: "", description: "Desc2"), favorite: false)

        vm.blockRecommendation(bookVM)
        XCTAssertTrue(model.blockedRecommendations.contains(id))
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
