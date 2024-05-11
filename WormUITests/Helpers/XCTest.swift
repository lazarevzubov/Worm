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

    /// Removes the app from the testing device.
    func deleteApp() {
        XCUIApplication().terminate()

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let icon = springboard.icons["Worm"]
        guard icon.exists else {
            return
        }

        icon.press(forDuration: 1.0)

        let removeAppButton = springboard.buttons["Remove App"]
        guard removeAppButton.waitForExistence(timeout: 5.0) else {
            return
        }
        removeAppButton.tap()

        let deleteAppButton = springboard.buttons["Delete App"]
        guard deleteAppButton.waitForExistence(timeout: 5.0) else {
            return
        }
        deleteAppButton.tap()

        let deleteButton = springboard.buttons["Delete"]
        guard deleteButton.waitForExistence(timeout: 5.0) else {
            return
        }
        deleteButton.tap()
    }

}
