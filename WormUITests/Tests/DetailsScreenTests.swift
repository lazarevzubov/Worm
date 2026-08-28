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
        _ = searchField.waitForExistence(timeout: 5.0)
        searchField.tap()
        searchField.typeText("The Master and Margarita") // Rating "4.6."

        let bookCell = app.bookRow(titled: "The Master and Margarita")
        guard bookCell.waitForExistence(timeout: 5.0) else {
            XCTFail("Book cell didn't appear.")
            return
        }

        while !bookCell.isHittable {
            app.swipeUp()
        }

        bookCell.tap()

        let ratingView = app.otherElements["4.6 out of 5 stars"]
        XCTAssertTrue(
            ratingView.waitForExistence(timeout: 5.0),
            "Rating view should be displayed for books with ratings."
        )
    }

    func test_whenBookHasNoRating_thenRatingViewIsNotDisplayed() {
        let app = openSearch()

        let searchField = app.searchFields.firstMatch
        _ = searchField.waitForExistence(timeout: 5.0)
        searchField.tap()
        searchField.typeText("The Lord of the Rings") // No rating.

        let bookCell = app.bookRow(titled: "The Lord of the Rings")
        guard bookCell.waitForExistence(timeout: 5.0) else {
            XCTFail("Book cell didn't appear.")
            return
        }

        while !bookCell.isHittable {
            app.swipeUp()
        }

        bookCell.tap()
        guard app.buttons["Close"].waitForExistence(timeout: 5.0) else {
            XCTFail("Details screen didn't appear.")
            return
        }

        if app
            .otherElements
            .allElementsBoundByIndex
            .first(where: { $0.label.matches("\\d\\.\\d out of 5 stars") }) != nil {
            XCTFail("Rating view should not be displayed for books without ratings.")
        }
    }

    // MARK: Private methods

    private func openSearch() -> XCUIApplication {
        let app = XCTestCase.makeTestApp()
        app.launch()

        let onboardingLabel = app.buttons["SearchOnboardingLabel"]
        if onboardingLabel.waitForExistence(timeout: 0.1) {
            onboardingLabel.tap()
        }

        let recommendationsOnboardingLabel = app.buttons["RecommendationsOnboardingLabel"]
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
