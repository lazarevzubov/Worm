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

    static let resetOnboardingEnvironmentKey = "RESET_ONBOARDING"

    // MARK: Private properties

    static let testEnvironmentKey = "TEST"

    // MARK: - Methods

    @MainActor
    static func makeTestApp(resetOnboarding: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()

        var environment = [testEnvironmentKey : "YES"]
        if resetOnboarding {
            environment[resetOnboardingEnvironmentKey] = "YES"
        }

        app.launchEnvironment = environment

        app.launchArguments += [
            "-AppleLanguages", 
            "(en)",
            "-AppleLocale",
            "en_US"
        ]

        return app
    }

}
