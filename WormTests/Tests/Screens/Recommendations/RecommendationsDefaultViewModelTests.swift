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

    func testRecommendations_initiallyEmpty() {
        let vm: some RecommendationsViewModel = RecommendationsDefaultViewModel(model: RecommendationsMockModel(),
                                                                                imageService: ImageMockService())
        XCTAssertTrue(vm.recommendations.isEmpty)
    }

    func testRecommendations_update() {
        let recommendations: Set = [Book(authors: [], title: "", id: "1")]
        let vm: some RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(recommendations: recommendations),
            imageService: ImageMockService()
        )

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any RecommendationsViewModel else {
                return false
            }
            return vm.recommendations == [BookViewModel(book: Book(authors: [], title: "", id: "1"), favorite: false)]
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        wait(for: [expectation], timeout: 3.0)
    }

    func testRecommendations_update_afterTogglingFavorite() async {
        let id = "1"
        let recommendations: Set = [Book(authors: [], title: "", id: id)]
        let vm: some RecommendationsViewModel = RecommendationsDefaultViewModel(
            model: RecommendationsMockModel(recommendations: recommendations),
            imageService: ImageMockService()
        )

        let predicate = NSPredicate { vm, _ in
            guard let vm = vm as? any RecommendationsViewModel else {
                return false
            }
            return vm.recommendations.isEmpty
        }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: vm)

        await vm.toggleFavoriteStateOfBook(withID: id)
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testTogglingFavorite_updatesModel() async {
        let model = RecommendationsMockModel()
        let vm: some RecommendationsViewModel = RecommendationsDefaultViewModel(model: model,
                                                                                imageService: ImageMockService())

        let id = "1"
        await vm.toggleFavoriteStateOfBook(withID: id)

        XCTAssertTrue(model.favoriteBookIDs.contains(id))
    }

    func testDetailsViewModel_authors_accordingToBook() {
        let authors = ["Author 1",
                       "Authors 2"]
        let bookVM = BookViewModel(book: Book(authors: authors, title: "Title", id: "1"), favorite: false)

        let vm: some RecommendationsViewModel = RecommendationsDefaultViewModel(model: RecommendationsMockModel(),
                                                                                imageService: ImageMockService())
        let detailsVM = vm.makeDetailsViewModel(for: bookVM)

        XCTAssertEqual(detailsVM.authors, "Author 1, Authors 2", "Unexpected authors string")
    }

    func testDetailsViewModel_title_accordingToBook() {
        let title = "Title"
        let bookVM = BookViewModel(book: Book(authors: ["Author 1",
                                                        "Authors 2"],
                                              title: title,
                                              id: "1"),
                                   favorite: false)

        let vm: some RecommendationsViewModel = RecommendationsDefaultViewModel(model: RecommendationsMockModel(),
                                                                                imageService: ImageMockService())
        let detailsVM = vm.makeDetailsViewModel(for: bookVM)

        XCTAssertEqual(detailsVM.title, "Title", "Unexpected title string")
    }

    func testDetailsViewModel_image_accordingToImageService() {
        let imageURL = URL(string: "https://apple.com")!
        let image = UIImage()
        let imageService = ImageMockService(images: [imageURL : image])

        let bookVM = BookViewModel(book: Book(authors: ["Author 1",
                                                        "Authors 2"],
                                              title: "Title",
                                              id: "1",
                                              imageURL: imageURL),
                                   favorite: false)

        let vm: some RecommendationsViewModel = RecommendationsDefaultViewModel(model: RecommendationsMockModel(),
                                                                                imageService: imageService)
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
        let vm: some RecommendationsViewModel = RecommendationsDefaultViewModel(model: model,
                                                                                imageService: ImageMockService())

        let id = "1"
        let bookVM = BookViewModel(book: Book(authors: [], title: "", id: id), favorite: false)

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
