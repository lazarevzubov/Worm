//
//  OnboardingPersistentServiceTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 4.5.2024.
//

@testable
import Worm
import XCTest

final class OnboardingPersistentServiceTests: XCTestCase {

    private static let suiteName = "com.lazarevzubov.OnboardingPersistentServiceTests"
    private let userDefaults = UserDefaults(suiteName: OnboardingPersistentServiceTests.suiteName)!

    // MARK: - Methods

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: Self.suiteName)
        super.tearDown()
    }

    func testOnboardingShown_false_whenNotSet() {
        let service = OnboardingPersistentService(userDefaults: userDefaults)
        XCTAssertFalse(service.onboardingShown)
    }

    func testOnboardingShown_setting() {
        let service = OnboardingPersistentService(userDefaults: userDefaults)

        let value = true
        service.onboardingShown = value

        XCTAssertEqual(service.onboardingShown, value, "onboardingShown returned an unexpected value.")
    }

}
