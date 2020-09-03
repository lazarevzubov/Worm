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

    // MARK: - Properties

    // MARK: Private properties

    private var mockedCells: [String] {
        return ["J.R.R. Tolkien – The Lord of the Rings",
                "Michael Bond – Paddington Pop-Up London",
                "J.K. Rowling – Harry Potter and the Sorcecer's Stone",
                "George R.R. Martin – A Game of Thrones",
                "Frank Herbert – Dune I",
                "Mikhail Bulgakov – The Master and Margarita",
                "Alan Moore – Watchmen",
                "Steve McConnell – Code Complete",
                "Jane Austen – Pride and Prejudice",
                "Martin Fowler – Refactoring: Improving the Design of Existing Code",
                "Stephen King – The Shining",
                "Hannah Arendt – Eichmann in Jerusalem: A Report on the Banality of Evil",
                "Fyodor Dostoyevsky – The Idiot",
                "Ken Kesey – Sometimes a Great Notion",
                "Haruki Murakami – The Wind-Up Bird Chronicle"]
    }

    // MARK: - Methods

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testScreenOpening() {
        let app = openedRecommendationsTab()
        XCTAssert(app.staticTexts["Recommendations"].exists)
    }

    func testListInitiallyEmpty() {
        let app = openedRecommendationsTab()
        XCTAssertTrue(app.tables.staticTexts.count == 0)
    }

    func testList() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["searchBar"]
        searchBar.tap()
        searchBar.typeText("Query")

        // Wait for update.
        let searchUpdated = NSPredicate(format: "count > 0")
        expectation(for: searchUpdated, evaluatedWith: app.tables.cells)
        waitForExpectations(timeout: 5.0)

        let title = mockedCells
            .map { $0.split(separator: "–").last!.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first!
        let uncheckedFavoriteButtonLabel = String(format: "SearchScreenFavoriteMarkUncheckedHintFormat", title)
        let uncheckedFavoriteButton = app.otherElements[uncheckedFavoriteButtonLabel].firstMatch
        uncheckedFavoriteButton.tap()

        let cancelButton = app.buttons["cancelSearchButton"]
        cancelButton.tap()

        let tabButton = app.buttons["Recommendations"]
        wait(forElement: tabButton)
        tabButton.tap()

        // Wait for update.
        let recommendationsUpdated = NSPredicate(format: "count > 0")
        expectation(for: recommendationsUpdated, evaluatedWith: app.tables.cells)
        waitForExpectations(timeout: 5.0)

        XCTAssertTrue(app.tables.cells.count > 0)
    }

    // MARK: Private properties

    private func openedRecommendationsTab() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()

        let tabButton = app.buttons["Recommendations"]
        tabButton.tap()

        return app
    }

}
