//
//  AppCoordinator.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 19.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Coordinator
import CoreData
import SwiftUI
import UIKit

/// Handles the navigation to and within the main screen of the app.
final class AppCoordinator: Coordinator {

    // MARK: - Properties

    // MARK: Private properties

    private let context: NSManagedObjectContext
    private let mockingService: Bool
    private weak var window: UIWindow?

    // MARK: - Initialization

    /**
     Creates a coordinator.

     - Parameters:
        - window: The app's key window.
        - mockingService: Indicates whether the app's UI shall be mocked.
     */
    init(window: UIWindow, context: NSManagedObjectContext, mockingService: Bool = false) {
        self.window = window
        self.context = context
        self.mockingService = mockingService
    }

    // MARK: - Methods

    // MARK: Coordinator protocol methods

    func start() {
        let view = MainFactory.makeMainView(context: context, mockingService: mockingService)
        let navigationView = NavigationView { view }
        let controller = UIHostingController(rootView: navigationView)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

}
