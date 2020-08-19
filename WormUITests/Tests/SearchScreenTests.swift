//
//  SearchScreenTests.swift
//  WormUITests
//
//  Created by Nikita Lazarev-Zubov on 20.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

final class SearchScreenTests: XCTestCase {

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

    func testSearchBarVisible() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["searchBar"]
        wait(forElement: searchBar)
        XCTAssertTrue(searchBar.exists)
        XCTAssertTrue(searchBar.isHittable)
    }

    func testKeyboardActivation() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["searchBar"]
        wait(forElement: searchBar)
        searchBar.tap()

        let updated = NSPredicate(format: "count > 0")
        expectation(for: updated, evaluatedWith: app.keyboards)
        waitForExpectations(timeout: 5.0)
    }

    func testResultsInitiallyEmpty() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tables.staticTexts.count == 0)
    }

    func testResults() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["searchBar"]
        wait(forElement: searchBar)
        searchBar.tap()
        searchBar.typeText("Query")

        // Waits for update.
        let updated = NSPredicate(format: "count > 0")
        expectation(for: updated, evaluatedWith: app.tables.cells)
        waitForExpectations(timeout: 2.0)

        var visibleCellsCount = 0
        let cells = app.tables.cells
        for cellIndex in 0..<cells.count {
            if cells.element(boundBy: cellIndex).isHittable {
                visibleCellsCount += 1
            } else {
                break
            }
        }

        // Depending on the screen size. In the specified order.
        for cellIndex in 0..<visibleCellsCount {
            let cell = app.otherElements[mockedCells[cellIndex]]
            XCTAssertTrue(cell.exists)
        }
    }

    func testFavoriteMarkInitiallyUnchecked() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["searchBar"]
        wait(forElement: searchBar)
        searchBar.tap()
        searchBar.typeText("Query")

        // Waits for update.
        let updated = NSPredicate(format: "count > 0")
        expectation(for: updated, evaluatedWith: app.tables.cells)
        waitForExpectations(timeout: 2.0)

        var visibleCellsCount = 0
        let cells = app.tables.cells
        for cellIndex in 0..<cells.count {
            if cells.element(boundBy: cellIndex).isHittable {
                visibleCellsCount += 1
            } else {
                break
            }
        }

        let expectedTexts = mockedCells
            .map { $0.split(separator: "–").last!.trimmingCharacters(in: .whitespacesAndNewlines) }
        // Depending on the screen size. In the specified order.
        for cellIndex in 0..<visibleCellsCount {
            let favoriteButton = app.otherElements[String(format: "SearchScreenFavoriteMarkUncheckedHintFormat",
                                                          expectedTexts[cellIndex])]
            XCTAssertTrue(favoriteButton.exists)
        }
    }

    func testCheckFavoriteMark() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["searchBar"]
        wait(forElement: searchBar)
        searchBar.tap()
        searchBar.typeText("Query")

        // Wait for update.
        let updated = NSPredicate(format: "count > 0")
        expectation(for: updated, evaluatedWith: app.tables.cells)
        waitForExpectations(timeout: 2.0)

        let title = mockedCells
            .map { $0.split(separator: "–").last!.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first!
        let uncheckedFavoriteButtonLabel = String(format: "SearchScreenFavoriteMarkUncheckedHintFormat", title)
        let uncheckedFavoriteButton = app.otherElements[uncheckedFavoriteButtonLabel].firstMatch

        XCTAssertTrue(uncheckedFavoriteButton.exists)
        XCTAssertTrue(uncheckedFavoriteButton.isHittable)
        uncheckedFavoriteButton.tap()

        let checkedFavoriteButtonLabel = String(format: "SearchScreenFavoriteMarkCheckedHintFormat", title)
        let checkedFavoriteButton = app.otherElements[checkedFavoriteButtonLabel].firstMatch

        XCTAssertTrue(checkedFavoriteButton.exists)
    }

    func testUncheckFavoriteMark() {
        let app = XCUIApplication()
        app.launch()

        let searchBar = app.searchFields["searchBar"]
        wait(forElement: searchBar)
        searchBar.tap()
        searchBar.typeText("Query")

        // Wait for update.
        let updated = NSPredicate(format: "count > 0")
        expectation(for: updated, evaluatedWith: app.tables.cells)
        waitForExpectations(timeout: 2.0)

        let title = mockedCells
            .map { $0.split(separator: "–").last!.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first!
        let uncheckedFavoriteButtonLabel = String(format: "SearchScreenFavoriteMarkUncheckedHintFormat", title)
        let uncheckedFavoriteButton = app.otherElements[uncheckedFavoriteButtonLabel].firstMatch

        XCTAssertTrue(uncheckedFavoriteButton.exists)
        XCTAssertTrue(uncheckedFavoriteButton.isHittable)
        uncheckedFavoriteButton.tap()

        let checkedFavoriteButtonLabel = String(format: "SearchScreenFavoriteMarkCheckedHintFormat", title)
        let checkedFavoriteButton = app.otherElements[checkedFavoriteButtonLabel].firstMatch

        XCTAssertTrue(checkedFavoriteButton.exists)
        XCTAssertTrue(checkedFavoriteButton.isHittable)
        checkedFavoriteButton.tap()

        XCTAssertTrue(uncheckedFavoriteButton.exists)
    }
    
}
