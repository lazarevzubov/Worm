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

    /// Waits for an UI element to appear.
    /// - Parameters:
    ///   - element: UI element that is waited to appear.
    ///   - timeout: Maximum amount of time in seconds to wait.
    func wait(forElement element: XCUIElement, timeout: TimeInterval = 5.0) {
        wait(forElement: element, toAppear: true, timeout: timeout)
    }

    /// Waits for an UI element to disappear.
    /// - Parameters:
    ///   - element: UI element that is waited to disappear.
    ///   - timeout: Maximum amount of time in seconds to wait.
    func waitForDisappearance(of element: XCUIElement, timeout: TimeInterval = 5.0) {
        wait(forElement: element, toAppear: false, timeout: timeout)
    }

    // MARK: Private methods

    private func wait(forElement element: XCUIElement, toAppear: Bool, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == \(toAppear ? 1 : 0)")
        expectation(for: predicate, evaluatedWith: element)

        waitForExpectations(timeout: timeout)
    }

}
