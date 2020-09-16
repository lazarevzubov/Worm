//
//  RecommendationsDefaultModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 4.8.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class RecommendationsDefaultModelTests: XCTestCase {

    // MARK: - Methods

    func testRecommendationsInitiallyEmpty() {
        let model = RecommendationsDefaultModel(catalogueService: CatalogueMockService(),
                                                favoritesService: FavoritesMockService())
        XCTAssertTrue(model.recommendations.isEmpty)
    }

    // TODO: Complement with proper tests.

}
