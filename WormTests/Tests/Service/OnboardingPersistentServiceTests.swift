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

    func testSearchOnboardingShown_false_whenNotSet() {
        let service = OnboardingPersistentService(userDefaults: userDefaults)
        XCTAssertFalse(service.searchOnboardingShown)
    }

    func testSearchOnboardingShown_setting() {
        let service = OnboardingPersistentService(userDefaults: userDefaults)

        let value = true
        service.searchOnboardingShown = value

        XCTAssertEqual(service.searchOnboardingShown, value, "searchOnboardingShown returned an unexpected value.")
    }

    func testRecommendationsOnboardingShown_false_whenNotSet() {
        let service = OnboardingPersistentService(userDefaults: userDefaults)
        XCTAssertFalse(service.recommendationsOnboardingShown)
    }

    func testRecommendationsOnboardingShown_setting() {
        let service = OnboardingPersistentService(userDefaults: userDefaults)

        let value = true
        service.recommendationsOnboardingShown = value

        XCTAssertEqual(service.recommendationsOnboardingShown,
                       value,
                       "recommendationsOnboardingShown returned an unexpected value.")
    }

}
