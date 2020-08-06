//
//  RecommendationsDefaultManagerTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 23.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
@testable
import Worm
import XCTest

final class RecommendationsDefaultManagerTests: XCTestCase {

    // MARK: - Methods

    func testRecommendationsInitiallyEmpty() {
        let manager = RecommendationsDefaultManager { _, _ in
            // Do nothing.
        }
        XCTAssertTrue(manager.recommendations.isEmpty)
    }

    func testAddNewRecommendationID() {
        let manager = RecommendationsDefaultManager { $1(Book(authors: ["Author"], title: "Title", id: $0)) }

        manager.addRecommendation(id: "1")
        XCTAssertEqual(manager.recommendations.count, 1)
    }

    func testAddExistingRecommendationID() {
        let manager = RecommendationsDefaultManager { $1(Book(authors: ["Author"], title: "Title", id: $0)) }

        let count = 2
        for _ in 0..<count {
            manager.addRecommendation(id: "1")
        }
        XCTAssertEqual(manager.recommendations.count, 1)
    }

    func testIncreaseRecommendationIDPriority() {
        let manager = RecommendationsDefaultManager { $1(Book(authors: ["Author"], title: "Title", id: $0)) }

        manager.addRecommendation(id: "1")
        manager.addRecommendation(id: "2")
        XCTAssertEqual(manager.recommendations.count, 2)

        manager.addRecommendation(id: "2")
        XCTAssertEqual(manager.recommendations.count, 2)
        XCTAssertEqual(manager.recommendations[0].id, "2") // Switched higher.
        XCTAssertEqual(manager.recommendations[1].id, "1")
    }

}
