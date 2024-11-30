//
//  OnboardingPersistentServiceTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 4.5.2024.
//

import Foundation
import Testing
@testable
import Worm

struct OnboardingPersistentServiceTests {

    // MARK: - Methods

    @Test
    func searchOnboarding_shown_false_whenNotSet() {
        let userDefaults = UserDefaults(suiteName: #function)!
        let service = OnboardingPersistentService(userDefaults: userDefaults)

        #expect(!service.searchOnboardingShown)
    }

    @Test
    func searchOnboarding_shown_setting() {
        let userDefaults = UserDefaults(suiteName: #function)!
        let service = OnboardingPersistentService(userDefaults: userDefaults)

        let value = true
        service.searchOnboardingShown = value

        #expect(service.searchOnboardingShown == value, "searchOnboardingShown returned an unexpected value.")
    }

    @Test
    func recommendationsOnboarding_shown_false_whenNotSet() {
        let userDefaults = UserDefaults(suiteName: #function)!
        let service = OnboardingPersistentService(userDefaults: userDefaults)

        #expect(!service.recommendationsOnboardingShown)
    }

    @Test
    func recommendationsOnboarding_shown_setting() {
        let userDefaults = UserDefaults(suiteName: #function)!
        let service = OnboardingPersistentService(userDefaults: userDefaults)

        let value = true
        service.recommendationsOnboardingShown = value

        #expect(
            service.recommendationsOnboardingShown == value,
            "recommendationsOnboardingShown returned an unexpected value."
        )
    }

}
