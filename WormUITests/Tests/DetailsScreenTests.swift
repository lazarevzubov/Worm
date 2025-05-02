//
//  DetailsScreenTests.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 2.5.2025.
//

import XCTest

@MainActor
final class BookDetailsViewUITests: XCTestCase {

    // MARK: - Methods

    func test_whenBookHasRating_thenRatingViewIsDisplayed() {
        let app = openSearch()

        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("The Master and Margarita") // Rating "4.6."

        let bookCell = app.staticTexts["The Master and Margarita"]
        while !bookCell.isHittable {
            app.swipeUp()
        }

        bookCell.tap()

        let ratingView = app.otherElements["4,6 out of 5 stars"]
        print(app.debugDescription)
        XCTAssertTrue(ratingView.exists, "Rating view should be displayed for books with ratings.")
    }

    func test_whenBookHasNoRating_thenRatingViewIsNotDisplayed() {
        let app = openSearch()

        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("The Lord of the Rings") // No rating.

        let bookCell = app.staticTexts["The Lord of the Rings"]
        while !bookCell.isHittable {
            app.swipeUp()
        }

        bookCell.tap()
        if app.otherElements.allElementsBoundByIndex.first(
            where: { $0.label.matches("\\d,\\d out of 5 stars") }
        ) != nil {
            XCTFail("Rating view should not be displayed for books without ratings.")
        }
    }

    // MARK: Private methods

    @MainActor
    private func openSearch() -> XCUIApplication {
        let app = XCTestCase.testApp
        app.launch()

        let onboardingLabel = app.staticTexts["SearchOnboardingLabel"]
        if onboardingLabel.waitForExistence(timeout: 0.1) {
            onboardingLabel.tap()
        }

        let recommendationsOnboardingLabel = app.staticTexts["RecommendationsOnboardingLabel"]
        if recommendationsOnboardingLabel.waitForExistence(timeout: 0.1) {
            recommendationsOnboardingLabel.tap()
        }

        return app
    }

}

// MARK: -

private extension String {

    // MARK: - Methods

    func matches(_ regex: String) -> Bool {
        range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

}
