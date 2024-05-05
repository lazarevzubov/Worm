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

    // Onboarding-related tests must be run first, because onboarding is only shown once.

    func test1Onboarding_shown() {
        let app = XCTestCase.testApp
        app.launch()

        let onboardingLabel = app.staticTexts["OnboardingLabel"]
        
        wait(forElement: onboardingLabel)
        XCTAssertTrue(onboardingLabel.exists)
        XCTAssertTrue(onboardingLabel.isHittable)
    }

    func test2Onboarding_disappears_onTapping() {
        let app = XCTestCase.testApp
        app.launch()

        let onboardingLabel = app.staticTexts["OnboardingLabel"]
        wait(forElement: onboardingLabel)
        
        onboardingLabel.tap()

        waitForDisappearance(of: onboardingLabel)
        XCTAssertFalse(onboardingLabel.exists)
        XCTAssertFalse(onboardingLabel.isHittable)
    }

    func test3Onboarding_notShown_again() {
        let app = XCTestCase.testApp
        app.launch()

        let onboardingLabel = app.staticTexts["OnboardingLabel"]
        
        waitForDisappearance(of: onboardingLabel) // Same as "not appearance."
        XCTAssertFalse(onboardingLabel.exists)
        XCTAssertFalse(onboardingLabel.isHittable)
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
