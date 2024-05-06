//
//  SearchScreenTests.swift
//  WormUITests
//
//  Created by Nikita Lazarev-Zubov on 20.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

final class SearchScreenTests: XCTestCase {

    // FIXME: Don't relay on hardcoded localizables.

    // MARK: - Methods

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

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

        waitForDisappearance(of: onboardingLabel, timeout: 5.0)
        XCTAssertFalse(onboardingLabel.exists, "Search onboarding didn't disappear.")
        XCTAssertFalse(onboardingLabel.isHittable, "Search onboarding is tappable.")
    }

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
        waitForDisappearance(of: onboardingLabel, timeout: 5.0)
        
        app.terminate()
        app.launch()

        guard onboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }
    }

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
        waitForDisappearance(of: searchOnboardingLabel, timeout: 5.0)

        let recommendationsOnboardingLabel = app.staticTexts["RecommendationsOnboardingLabel"]
        guard recommendationsOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding didn't appear.")
            return
        }

        XCTAssertTrue(recommendationsOnboardingLabel.exists, "Recommendations onboarding didn't appear.")
        XCTAssertTrue(recommendationsOnboardingLabel.isHittable, "Recommendations onboarding isn't tappable.")
    }

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

        waitForDisappearance(of: recommendationsOnboardingLabel, timeout: 5.0)
        XCTAssertFalse(recommendationsOnboardingLabel.exists, "Recommendations onboarding didn't disappear.")
        XCTAssertFalse(recommendationsOnboardingLabel.isHittable, "Recommendations onboarding is tappable.")
    }

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
        waitForDisappearance(of: recommendationsOnboardingLabel, timeout: 5.0)

        app.terminate()
        app.launch()

        guard !searchOnboardingLabel.waitForExistence(timeout: 5.0) else {
            XCTFail("Search onboarding appeared again.")
            return
        }
    }

    func testSearchInitiallyShown() {
        let app = XCTestCase.testApp
        app.launch()

        XCTAssert(app.staticTexts["Search"].exists)
    }

    func testSearchBarVisible() {
        let app = XCTestCase.testApp
        app.launch()

        let searchBar = app.navigationBars.searchFields.element(boundBy: 0)
        wait(forElement: searchBar)
        XCTAssertTrue(searchBar.exists)
        XCTAssertTrue(searchBar.isHittable)
    }

    func testKeyboardActivation() {
        let app = XCTestCase.testApp
        app.launch()

        let searchBar = app.navigationBars.searchFields.element(boundBy: 0)
        wait(forElement: searchBar)
        searchBar.tap()

        let keyboardActivated = NSPredicate(format: "count > 0")
        expectation(for: keyboardActivated, evaluatedWith: app.keyboards)
        waitForExpectations(timeout: 5.0)
    }

    func testCancelSearchButtonVisible() {
        let app = XCTestCase.testApp
        app.launch()

        let searchBar = app.navigationBars.searchFields.element(boundBy: 0)
        wait(forElement: searchBar)
        searchBar.tap()

        let cancelButton = app.buttons["Cancel"]
        wait(forElement: cancelButton)
        XCTAssertTrue(cancelButton.exists)
        XCTAssertTrue(cancelButton.isHittable)
    }

    func testCancelButtonHidesKeyboard() {
        let app = XCTestCase.testApp
        app.launch()

        let searchBar = app.navigationBars.searchFields.element(boundBy: 0)
        wait(forElement: searchBar)
        searchBar.tap()

        let cancelButton = app.navigationBars.buttons["Cancel"]
        wait(forElement: cancelButton)

        let keyboardActivated = NSPredicate(format: "count > 0")
        expectation(for: keyboardActivated, evaluatedWith: app.keyboards)
        waitForExpectations(timeout: 5.0)

        cancelButton.tap()

        let keyboardDeactivated = NSPredicate(format: "count == 0")
        expectation(for: keyboardDeactivated, evaluatedWith: app.keyboards)
        waitForExpectations(timeout: 5.0)
    }

    func testResultsInitiallyEmpty() {
        let app = XCTestCase.testApp
        app.launch()

        XCTAssertTrue(app.tables.staticTexts.count == 0)
    }

}
