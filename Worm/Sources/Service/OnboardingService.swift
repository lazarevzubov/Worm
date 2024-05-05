//
//  OnboardingService.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 4.5.2024.
//

import Foundation

/// Provides with information related to the user onboarding.
protocol OnboardingService {

    // MARK: - Properties

    /// Whether the onboarding has been already shown to the user.
    var onboardingShown: Bool { get set }

}

// MARK: -

/// Provides with information related to the user onboarding from a persistent source.
final class OnboardingPersistentService: OnboardingService {

    // MARK: - Properties

    // MARK: OnboardingService protocol properties

    var onboardingShown: Bool {
        get { userDefaults.bool(forKey: .onboardingShown) }
        set { userDefaults.setValue(newValue, forKey: .onboardingShown) }
    }

    // MARK: Private properties

    private let userDefaults: UserDefaults

    // MARK: - Initialization

    /// Creates an object that provides with information related to the user onboarding.
    /// - Parameter userDefaults: An interface to the user’s defaults database, where the app stores key-value pairs persistently across launches of the
    ///     app.
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

}

// MARK: -

private typealias UserDefaultsKey = String

// MARK: -

private extension UserDefaultsKey {

    // MARK: - Properties

    static let onboardingShown = "onboardingShown"

}
