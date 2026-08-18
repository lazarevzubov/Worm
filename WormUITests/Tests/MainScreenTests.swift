//
//  MainScreenTests.swift
//  WormUITests
//
//  Created by Lazarev-Zubov, Nikita on 18.7.2026.
//

import XCTest

@MainActor
final class MainScreenTests: XCTestCase {

    // MARK: - Methods

    func testSearchTab_visible() {
        let app = launchedApp()
        XCTAssertTrue(app.element(withIdentifier: "SearchTabButton").isHittable)
    }

    func testSearchTab_selectedByDefault() {
        let app = launchedApp()
        XCTAssertTrue(
            app.isTabSelected(withIdentifier: "SearchTabButton"), "The Search tab should be selected on first launch."
        )
    }

    func testRecommendationsTab_visible() {
        let app = launchedApp()
        XCTAssertTrue(app.element(withIdentifier: "RecommendationsTabButton").isHittable)
    }

    func testTappingRecommendationsTab_showsRecommendationsScreen() {
        let app = launchedApp()
        app.element(withIdentifier: "RecommendationsTabButton").tap()

        XCTAssertTrue(app.isScreenVisible(titled: "Recommendations"))
    }

    func testFavoritesTab_visible() {
        let app = launchedApp()
        XCTAssertTrue(app.element(withIdentifier: "FavoritesTabButton").isHittable)
    }

    func testTappingFavoritesTab_showsFavoritesScreen() {
        let app = launchedApp()
        app.element(withIdentifier: "FavoritesTabButton").tap()

        XCTAssertTrue(app.isScreenVisible(titled: "Favorites"))
    }

    func testBlockedTab_visible() {
        let app = launchedApp()
        XCTAssertTrue(app.element(withIdentifier: "BlockedTabButton").isHittable)
    }

    func testTappingBlockedTab_showsBlockedScreen() {
        let app = launchedApp()
        app.element(withIdentifier: "BlockedTabButton").tap()

        XCTAssertTrue(app.isScreenVisible(titled: "Blocked"))
    }

    // MARK: Private methods

    private func launchedApp() -> XCUIApplication {
        let app = XCTestCase.makeTestApp()
        app.launch()

        let searchOnboardingLabel = app.buttons["SearchOnboardingLabel"]
        if searchOnboardingLabel.waitForExistence(timeout: 0.1) {
            searchOnboardingLabel.tap()
        }

        let recommendationsOnboardingLabel = app.buttons["RecommendationsOnboardingLabel"]
        if recommendationsOnboardingLabel.waitForExistence(timeout: 0.1) {
            recommendationsOnboardingLabel.tap()
        }

        return app
    }

}
