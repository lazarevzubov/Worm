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
        let presenter = RecommendationsDefaultPresenter(recommendationsModel: model, updateQueue: queue)

        let books = [Book(authors: [], title: "Title1", id: "1"),
                     Book(authors: [], title: "Title2", id: "2")]
        model.recommendations = books

        queue.sync {
            // Wait for presenter update.
        }

        let bookVMsSet = Set(books.map { $0.asViewModel(favorite: false) })
        XCTAssertEqual(Set(presenter.recommendations), bookVMsSet)
    }

}

// MARK: -

private final class RecommendationsMockModel: RecommendationsModel {

    // MARK: - Properties

    private(set) var recommendationsFetched = false

    // MARK: RecommendationsManager protocol properties

    @Published
    var recommendations = [Book]()
    private(set) var favoriteBookIDs = [String]()

    // MARK: - Initiazliation

    init(recommendations: [Book] = []) {
        self.recommendations = recommendations
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocl methods

    func fetchRecommendations() {
        recommendationsFetched = true
    }

}
