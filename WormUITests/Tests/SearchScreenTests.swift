//
//  SearchScreenTests.swift
//  WormUITests
//
//  Created by Nikita Lazarev-Zubov on 20.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

final class SearchScreenTests: XCTestCase {

    // FIXME: Don't rely on hardcoded localizables.

    // MARK: - Methods

    @MainActor
    func testSearchOnboarding_shown_onFirstLaunch() {
        deleteApp()

        let app = XCTestCase.testApp
        app.launch()

        let onboardingLabel = app.staticTexts["SearchOnboardingLabel"]
        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }

        XCTAssertTrue(onboardingLabel.exists, "Search onboarding didn't appear.")
        XCTAssertTrue(onboardingLabel.isHittable, "Search onboarding isn't tappable.")
    }

    @MainActor
    func testSearchOnboarding_disappears_onTap() {
        deleteApp()

        let app = XCTestCase.testApp
        app.launch()

        let onboardingLabel = app.staticTexts["SearchOnboardingLabel"]
        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }
        onboardingLabel.tap()

        guard !onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't disappear.")
            return
        }
        XCTAssertFalse(onboardingLabel.isHittable, "Search onboarding is tappable.")
    }

    @MainActor
    func testSearchOnboarding_shownTwice() {
        deleteApp()

        let app = XCTestCase.testApp
        app.launch()

        let onboardingLabel = app.staticTexts["SearchOnboardingLabel"]
        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }

        onboardingLabel.tap()
        guard !onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't disappear.")
            return
        }

        app.terminate()
        app.launch()

        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }
    }

    @MainActor
    func testRecommendationsOnboarding_appears_onSearchOnboarding_disappearing() {
        deleteApp()

        let app = XCTestCase.testApp
        app.launch()

        let searchOnboardingLabel = app.staticTexts["SearchOnboardingLabel"]
        guard searchOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }

        searchOnboardingLabel.tap()
        guard !searchOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't disappear.")
            return
        }

        let recommendationsOnboardingLabel = app.staticTexts["RecommendationsOnboardingLabel"]
        guard recommendationsOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }

        XCTAssertTrue(recommendationsOnboardingLabel.exists, "Recommendations onboarding didn't appear.")
        XCTAssertTrue(recommendationsOnboardingLabel.isHittable, "Recommendations onboarding isn't tappable.")
    }

    @MainActor
    func testRecommendationsOnboarding_disappears_onTap() {
        deleteApp()

        let app = XCTestCase.testApp
        app.launch()

        let searchOnboardingLabel = app.staticTexts["SearchOnboardingLabel"]
        guard searchOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }
        searchOnboardingLabel.tap()

        let recommendationsOnboardingLabel = app.staticTexts["RecommendationsOnboardingLabel"]
        guard recommendationsOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }

        recommendationsOnboardingLabel.tap()
        guard !recommendationsOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't disappear.")
            return
        }

        XCTAssertFalse(recommendationsOnboardingLabel.exists, "Recommendations onboarding didn't disappear.")
        XCTAssertFalse(recommendationsOnboardingLabel.isHittable, "Recommendations onboarding is tappable.")
    }

    @MainActor
    func testSearchOnboarding_notShownTwice_afterRecommendationsOnboardingDismissal() {
        deleteApp()

        let app = XCTestCase.testApp
        app.launch()

        let searchOnboardingLabel = app.staticTexts["SearchOnboardingLabel"]
        guard searchOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }
        searchOnboardingLabel.tap()

        let recommendationsOnboardingLabel = app.staticTexts["RecommendationsOnboardingLabel"]
        guard recommendationsOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }

        recommendationsOnboardingLabel.tap()
        guard !recommendationsOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't disappear.")
            return
        }

        app.terminate()
        app.launch()

        guard !searchOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding appeared again.")
            return
        }
    }

    @MainActor
    func testSearch_isPresent() {
        let app = XCTestCase.testApp
        app.launch()

        XCTAssert(app.staticTexts["Search"].exists)
    }

    @MainActor
    func testSearchBarVisible() {
        let app = XCTestCase.testApp
        app.launch()

        let searchBar = app.navigationBars.searchFields.element(boundBy: 0)
        guard searchBar.waitForExistence(timeout: 5.0) else {
            XCTFail("Search bar didn't appear.")
            return
        }

        XCTAssertTrue(searchBar.exists)
        XCTAssertTrue(searchBar.isHittable)
    }

    @MainActor
    func testKeyboardActivation() {
        let app = XCTestCase.testApp
        app.launch()

        let searchBar = app.navigationBars.searchFields.element(boundBy: 0)
        guard searchBar.waitForExistence(timeout: 5.0) else {
            XCTFail("Search bar didn't appear.")
            return
        }
        searchBar.tap()

        let keyboardActivated = NSPredicate(format: "count > 0")
        expectation(for: keyboardActivated, evaluatedWith: app.keyboards)
        waitForExpectations(timeout: 5.0)
    }

    @MainActor
    func testCancelSearchButtonVisible() {
        let app = XCTestCase.testApp
        app.launch()

        let searchBar = app.navigationBars.searchFields.element(boundBy: 0)
        guard searchBar.waitForExistence(timeout: 5.0) else {
            XCTFail("Search bar didn't appear.")
            return
        }
        searchBar.tap()

        let cancelButton = app.buttons["Cancel"]
        guard searchBar.waitForExistence(timeout: 5.0) else {
            XCTFail("Search bar didn't appear.")
            return
        }

        XCTAssertTrue(cancelButton.exists)
        XCTAssertTrue(cancelButton.isHittable)
    }

    @MainActor
    func testCancelButtonHidesKeyboard() {
        let app = XCTestCase.testApp
        app.launch()

        let searchBar = app.navigationBars.searchFields.element(boundBy: 0)
        guard searchBar.waitForExistence(timeout: 5.0) else {
            XCTFail("Search bar didn't appear.")
            return
        }
        searchBar.tap()

        let cancelButton = app.navigationBars.buttons["Cancel"]
        guard cancelButton.waitForExistence(timeout: 5.0) else {
            XCTFail("Cancel button bar didn't appear.")
            return
        }

        let keyboardActivated = NSPredicate(format: "count > 0")
        expectation(for: keyboardActivated, evaluatedWith: app.keyboards)
        waitForExpectations(timeout: 5.0)

        cancelButton.tap()

        let keyboardDeactivated = NSPredicate(format: "count == 0")
        expectation(for: keyboardDeactivated, evaluatedWith: app.keyboards)
        waitForExpectations(timeout: 5.0)
    }

    @MainActor
    func testResultsInitiallyEmpty() {
        let app = XCTestCase.testApp
        app.launch()

        XCTAssertTrue(app.tables.staticTexts.count == 0)
    }

}
