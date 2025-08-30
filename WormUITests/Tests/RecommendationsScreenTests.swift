//
//  RecommendationsScreenTests.swift
//  WormUITests
//
//  Created by Nikita Lazarev-Zubov on 19.8.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

final class RecommendationsScreenTests: XCTestCase {

    // FIXME: Don't rely on hardcoded localizables.

    // MARK: - Methods

    @MainActor
    func testScreenOpening() {
        let app = openedRecommendationsTab()
        XCTAssert(app.staticTexts["Recommendations"].exists)
    }

    @MainActor
    func testOnboarding_shown_onFirstLaunch() {
        deleteApp()
        let app = openedRecommendationsTab()

        let onboardingLabel = app.staticTexts["OnboardingLabel"]
        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Onboarding didn't appear.")
            return
        }

        XCTAssertTrue(onboardingLabel.exists, "Onboarding didn't appear.")
        XCTAssertTrue(onboardingLabel.isHittable, "Onboarding isn't tappable.")
    }

    @MainActor
    func testOnboarding_disappears_onTap() {
        deleteApp()
        let app = openedRecommendationsTab()

        let onboardingLabel = app.staticTexts["OnboardingLabel"]
        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Onboarding didn't appear.")
            return
        }
        onboardingLabel.tap()

        guard !onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Onboarding didn't disappear.")
            return
        }
        XCTAssertFalse(onboardingLabel.isHittable, "Oboarding is tappable.")
    }

    @MainActor
    func testOnboarding_notShownTwice_afterDismissal() {
        deleteApp()
        let app = openedRecommendationsTab()

        let onboardingLabel = app.staticTexts["OnboardingLabel"]
        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Onboarding didn't appear.")
            return
        }
        onboardingLabel.tap()

        guard !onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Onboarding didn't disappear.")
            return
        }

        app.terminate()
        _ = openedRecommendationsTab()

        guard !onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Onboarding appeared again.")
            return
        }
    }

    @MainActor
    func testListInitiallyEmpty() {
        let app = openedRecommendationsTab()
        XCTAssertTrue(app.tables.staticTexts.count == 0)
    }

    @MainActor
    func testFiltersButton_isVisible() {
        let app = openedRecommendationsTab()
        XCTAssertTrue(app.buttons["RecommendationsFiltersButton"].isHittable)
    }

    @MainActor
    func testTopRatedButton_isVisible_whenFiltersButton_isTapped() {
        let app = openedRecommendationsTab()
        app.buttons["RecommendationsFiltersButton"].tap()

        let topRatedButton = app.buttons["Top rated"]
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))

        XCTAssertTrue(topRatedButton.isHittable)
    }

    // MARK: Private properties

    @MainActor
    private func openedRecommendationsTab() -> XCUIApplication {
        let app = XCTestCase.testApp
        app.launch()

        let tabButton = app.tabBars.buttons["Recommendations"]
        tabButton.tap()

        return app
    }

}
