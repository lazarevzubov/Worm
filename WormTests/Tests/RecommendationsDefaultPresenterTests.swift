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

    func testRecommendationsInitiallyEmpty() {
        let presenter = RecommendationsDefaultPresenter(model: RecommendationsMockModel(),
                                                        recommendationsManager: RecommendationsMockManager())
        XCTAssertTrue(presenter.recommendations.isEmpty)
    }

    func testRocommendationsUpdateOnInit() {
        let bookID = "1"
        let books = [Book(authors: [], title: "Title", id: bookID, similarBookIDs: [bookID])]
        let model = RecommendationsMockModel(books: books)
        let recommendationsManager = RecommendationsMockManager(books: books)

        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.RecommendationsDefaultPresenterTests")
        let presenter = RecommendationsDefaultPresenter(model: model,
                                                        recommendationsManager: recommendationsManager,
                                                        updateQueue: queue)
        queue.sync {
            // Just sync the the presenter update.
        }

        XCTAssertEqual(presenter.recommendations, books.map { $0.asViewModel(favorite: true) })
    }

    func testRecommendationsUpdate() {
        let bookID = "1"
        let books = [Book(authors: [], title: "Title", id: bookID, similarBookIDs: [bookID])]
        let recommendationsManager = RecommendationsMockManager(books: books)

        let queue = DispatchQueue(label: "com.LazarevZubov.Worm.RecommendationsDefaultPresenterTests")
        let presenter = RecommendationsDefaultPresenter(model: RecommendationsMockModel(),
                                                        recommendationsManager: recommendationsManager,
                                                        updateQueue: queue)

        recommendationsManager.addRecommendation(id: bookID)
        queue.sync {
            // Just sync the the presenter update.
        }
        XCTAssertEqual(presenter.recommendations, books.map { $0.asViewModel(favorite: true) })
    }

}

// MARK: -

private struct RecommendationsMockModel: RecommendationsModel {

    // MARK: - Properties

    // MARK: RecommendationsModel protocol properties

    var favoriteBookIDs: [String] {
        return books.map { $0.id }
    }

    // MARK: Private properties

    private let books: [Book]

    // MARK: - Initiazliation

    init(books: [Book] = [Book]()) {
        self.books = books
    }

    // MARK: - Methods

    // MARK: RecommendationsModel protocol methods

    func getBook(by id: String, resultCompletion: @escaping (Book?) -> Void) {
        resultCompletion(books.first { $0.id == id })
    }

}

// MARK: -

private final class RecommendationsMockManager: RecommendationsManager {

    // MARK: - Properties

    // MARK: RecommendationsManager protocol properties

    @Published
    var recommendations = [Book]()

    // MARK: Private properties

    private let books: [Book]

    // MARK: - Initiazliation

    init(books: [Book] = [Book]()) {
        self.books = books
    }

    // MARK: - Methods

    // MARK: RecommendationsManager protocol methods

    func addRecommendation(id: String) {
        if let recommendedBook = books.first(where: { $0.id == id }) {
            recommendations.append(recommendedBook)
        }
    }

}
