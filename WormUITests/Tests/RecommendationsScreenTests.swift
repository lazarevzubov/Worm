//
//  RecommendationsScreenTests.swift
//  WormUITests
//
//  Created by Nikita Lazarev-Zubov on 19.8.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

@MainActor
final class RecommendationsScreenTests: XCTestCase {

    // FIXME: Don't rely on hardcoded localizables.

    // MARK: - Methods

    func testScreenOpening() {
        let app = makeOpenRecommendationsTab()
        XCTAssert(app.staticTexts["Recommendations"].exists)
    }

    func testOnboarding_shown_onFirstLaunch() {
        let app = makeOpenRecommendationsTab(resetOnboarding: true)

        let onboardingLabel = app.staticTexts["OnboardingLabel"]
        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Onboarding didn't appear.")
            return
        }

        XCTAssertTrue(onboardingLabel.exists, "Onboarding didn't appear.")
        XCTAssertTrue(onboardingLabel.isHittable, "Onboarding isn't tappable.")
    }

    func testOnboarding_disappears_onTap() {
        let app = makeOpenRecommendationsTab(resetOnboarding: true)

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

    func testOnboarding_notShownTwice_afterDismissal() {
        let app = makeOpenRecommendationsTab(resetOnboarding: true)

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
        _ = makeOpenRecommendationsTab()

        guard !onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Onboarding appeared again.")
            return
        }
    }

    func testListInitiallyEmpty() {
        let app = makeOpenRecommendationsTab()
        XCTAssertTrue(app.tables.staticTexts.count == 0)
    }

    func testFiltersButton_isVisible() {
        let app = makeOpenRecommendationsTab()
        XCTAssertTrue(app.buttons["RecommendationsFiltersButton"].isHittable)
    }

    func testTopRatedButton_isVisible_whenFiltersButton_isTapped() {
        let app = makeOpenRecommendationsTab()
        app.buttons["RecommendationsFiltersButton"].tap()

        let topRatedButton = app.buttons["Top rated"]
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))

        XCTAssertTrue(topRatedButton.isHittable)
    }

    // MARK: Private properties

    private func makeOpenRecommendationsTab(resetOnboarding: Bool = false) -> XCUIApplication {
        let app = XCTestCase.makeTestApp(resetOnboarding: resetOnboarding)
        app.launch()

        let tabButton = app.tabBars.buttons["Recommendations"]
        tabButton.tap()

        return app
    }

}
