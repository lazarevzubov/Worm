//
//  BlockedScreenTests.swift
//  WormUITests
//
//  Created by Nikita Lazarev-Zubov on 10.8.2026.
//  Copyright © 2026 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

@MainActor
final class BlockedScreenTests: XCTestCase {

    // MARK: - Methods

    func testListInitiallyEmpty() {
        let app = XCTestCase.makeTestApp()
        app.launch()

        dismissOnboarding(in: app)

        app.tabBars.buttons["Blocked"].tap()

        XCTAssertTrue(app.tables.staticTexts.count == 0)
    }

    func testBlockedBook_appearsAfterBlocking_andDisappearsAfterUnblocking() {
        let app = XCTestCase.makeTestApp()
        app.launch()

        dismissOnboarding(in: app)

        favoriteBook(titled: "The Lord of the Rings", in: app)

        app.tabBars.buttons["Recommendations"].tap()

        let recommendedBook = app.staticTexts["The Wind-Up Bird Chronicle"]
        guard recommendedBook.waitForExistence(timeout: 5.0) else {
            XCTFail("Recommendation didn't appear.")
            return
        }
        recommendedBook.swipeLeft()

        app.buttons["Delete"].tap()
        app.tabBars.buttons["Blocked"].tap()

        let blockedBook = app.staticTexts["The Wind-Up Bird Chronicle"]
        guard blockedBook.waitForExistence(timeout: 5.0) else {
            XCTFail("Blocked book didn't appear.")
            return
        }
        blockedBook.swipeLeft()

        app.buttons["Unblock"].tap()

        guard !blockedBook.waitForExistence(timeout: 5.0) else {
            XCTFail("Blocked book didn't disappear after unblocking.")
            return
        }

        app.tabBars.buttons["Recommendations"].tap()
        XCTAssertTrue(
            app.staticTexts["The Wind-Up Bird Chronicle"].waitForExistence(timeout: 5.0),
            "Book didn't reappear as a recommendation after unblocking."
        )
    }

    // MARK: Private methods

    private func dismissOnboarding(in app: XCUIApplication) {
        let searchOnboardingLabel = app.buttons["SearchOnboardingLabel"]
        if searchOnboardingLabel.waitForExistence(timeout: 0.1) {
            searchOnboardingLabel.tap()
        }

        let recommendationsOnboardingLabel = app.buttons["RecommendationsOnboardingLabel"]
        if recommendationsOnboardingLabel.waitForExistence(timeout: 0.1) {
            recommendationsOnboardingLabel.tap()
        }
    }

    private func favoriteBook(titled title: String, in app: XCUIApplication) {
        let searchField = app.navigationBars.searchFields.element(boundBy: 0)
        searchField.tap()
        searchField.typeText(title)

        let favoriteButton = app.otherElements["\(title) favorite unchecked"]
        guard favoriteButton.waitForExistence(timeout: 5.0) else {
            XCTFail("Favorite button didn't appear.")
            return
        }
        favoriteButton.tap()

        guard app.otherElements["\(title) favorite checked"].waitForExistence(timeout: 5.0) else {
            XCTFail("Book wasn't favorited.")
            return
        }

        app.navigationBars.buttons["Close"].tap()
    }

}
