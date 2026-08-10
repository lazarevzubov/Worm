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
        XCTAssertTrue(app.tabBars.buttons["SearchTabButton"].isHittable)
    }

    func testSearchTab_selectedByDefault() {
        let app = launchedApp()
        XCTAssertTrue(app.staticTexts["Search"].exists, "The Search tab should be selected on first launch.")
    }

    func testRecommendationsTab_visible() {
        let app = launchedApp()
        XCTAssertTrue(app.tabBars.buttons["RecommendationsTabButton"].isHittable)
    }

    func testTappingRecommendationsTab_showsRecommendationsScreen() {
        let app = launchedApp()
        app.tabBars.buttons["RecommendationsTabButton"].tap()

        XCTAssertTrue(app.staticTexts["Recommendations"].exists)
    }

    func testFavoritesTab_visible() {
        let app = launchedApp()
        XCTAssertTrue(app.tabBars.buttons["FavoritesTabButton"].isHittable)
    }

    func testTappingFavoritesTab_showsFavoritesScreen() {
        let app = launchedApp()
        app.tabBars.buttons["FavoritesTabButton"].tap()

        XCTAssertTrue(app.staticTexts["Favorites"].exists)
    }

    func testBlockedTab_visible() {
        let app = launchedApp()
        XCTAssertTrue(app.tabBars.buttons["BlockedTabButton"].isHittable)
    }

    func testTappingBlockedTab_showsBlockedScreen() {
        let app = launchedApp()
        app.tabBars.buttons["BlockedTabButton"].tap()

        XCTAssertTrue(app.staticTexts["Blocked"].exists)
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
