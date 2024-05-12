//
//  RecommendationsScreenTests.swift
//  WormUITests
//
//  Created by Nikita Lazarev-Zubov on 19.8.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

final class RecommendationsScreenTests: XCTestCase {

    // FIXME: Don't relay on hardcoded localizables.

    // MARK: - Methods

    func testScreenOpening() {
        let app = openedRecommendationsTab()
        XCTAssert(app.staticTexts["Recommendations"].exists)
    }

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

    func testListInitiallyEmpty() {
        let app = openedRecommendationsTab()
        XCTAssertTrue(app.tables.staticTexts.count == 0)
    }

    // MARK: Private properties

    private func openedRecommendationsTab() -> XCUIApplication {
        let app = XCTestCase.testApp
        app.launch()

        let tabButton = app.tabBars.buttons["Recommendations"]
        tabButton.tap()

        return app
    }

}
