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

    // TODO.

}

// MARK: -

private final class RecommendationsMockModel: RecommendationsModel {

    // MARK: - Properties

    private(set) var recommendationsFetched = false

    // MARK: RecommendationsManager protocol properties

    @Published
    var recommendations = [Book]()

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
