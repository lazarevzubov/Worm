//
//  RecommendationsDefaultPresenterTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 3.8.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class RecommendationsDefaultPresenterTests: XCTestCase {

    // MARK: - Methods

    func testRecommendationsUpdate() {
        let model = RecommendationsMockModel()
        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.RecommendationsDefaultPresenterTests")
        let presenter = RecommendationsDefaultPresenter(model: model, updateQueue: queue)

        let books = [Book(authors: [], title: "Title1", id: "1"),
                     Book(authors: [], title: "Title2", id: "2")]
        model.recommendations = books

        queue.sync {
            // Wait for presenter update.
        }

        let bookVMsSet = Set(books.map { $0.asViewModel(favorite: false) })
        XCTAssertEqual(Set(presenter.recommendations), bookVMsSet)
    }

    func testToggleFavoriteState() {
        let model = RecommendationsMockModel()

        let bookID1 = "1"
        let bookID2 = "2"
        model.favoriteBookIDs = [bookID1, bookID2]

        let presenter = RecommendationsDefaultPresenter(model: model)

        presenter.toggleFavoriteState(bookID: bookID1)
        XCTAssertEqual(model.favoriteBookIDs, [bookID2])

        presenter.toggleFavoriteState(bookID: bookID1)
        XCTAssertEqual(Set(model.favoriteBookIDs), Set([bookID2, bookID1]))
    }

    func testBlockRecommendation() {
        let model = RecommendationsMockModel()

        let presenter = RecommendationsDefaultPresenter(model: model)
        XCTAssertTrue(model.blockedRecommendationIDs.isEmpty)

        let id = "1"
        presenter.block(recommendation: BookViewModel(authors: "Authors",
                                                      id: id,
                                                      imageURL: nil,
                                                      isFavorite: false,
                                                      title: "Title"))
        XCTAssertEqual(model.blockedRecommendationIDs, [id])
    }

}

// MARK: -

private final class RecommendationsMockModel: RecommendationsModel {

    // MARK: - Properties

    private(set) var blockedRecommendationIDs = [String]()
    private(set) var recommendationsFetched = false

    // MARK: RecommendationsManager protocol properties

    @Published
    var recommendations = [Book]()
    var favoriteBookIDs = [String]()

    // MARK: - Initiazliation

    init(recommendations: [Book] = []) {
        self.recommendations = recommendations
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocl methods

    func fetchRecommendations() {
        recommendationsFetched = true
    }

    func toggleFavoriteState(bookID: String) {
        if favoriteBookIDs.contains(where: { $0 == bookID }) {
            favoriteBookIDs.removeAll { $0 == bookID }
        } else {
            favoriteBookIDs.append(bookID)
        }
    }

    func blockFromRecommendations(bookID: String) {
        blockedRecommendationIDs.append(bookID)
    }

}
