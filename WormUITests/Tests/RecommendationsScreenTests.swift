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

    override func setUp() {
        super.setUp()
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

    // MARK: Private properties

    private func openedRecommendationsTab() -> XCUIApplication {
        let app = XCTestCase.testApp
        app.launch()

        let tabButton = app.tabBars.buttons["Recommendations"]
        tabButton.tap()

        return app
    }

}
