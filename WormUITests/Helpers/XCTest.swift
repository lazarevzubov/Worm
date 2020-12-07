//
//  XCTest.swift
//  WormUITests
//
//  Created by Nikita Lazarev-Zubov on 20.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import XCTest

extension XCTestCase {

    // MARK: - Properties

    /// The application under test instance with the `TEST` flag added to the launch environment.
    static var testApp: XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment = ["TEST": "YES"]

        return app
    }

    // MARK: - Methods

    /**
     Waits for an UI element to appear.

     - Parameters:
        - element: UI element that is waited to appear.
        - timeout: Maximum amount of time in seconds to wait.
     */
    func wait(forElement element: XCUIElement, timeout: TimeInterval = 5.0) {
        let predicate = NSPredicate(format: "exists == 1")
        expectation(for: predicate, evaluatedWith: element)

        waitForExpectations(timeout: timeout)
    }

}
