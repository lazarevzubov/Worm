//
//  OnboardingMockService.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 13.5.2024.
//

@testable
import Worm

final class OnboardingMockService: OnboardingService {

    // MARK: - Properties

    // MARK: OnboardingService protocol properties

    var recommendationsOnboardingShown: Bool
    var searchOnboardingShown: Bool

    // MARK: - Initialization

    init(onboardingShown: Bool = false) {
        self.recommendationsOnboardingShown = onboardingShown
        self.searchOnboardingShown = onboardingShown
    }

}
