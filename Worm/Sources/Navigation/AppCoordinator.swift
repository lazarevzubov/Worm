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

    private let catalogueService: CatalogueService
    private let context: NSManagedObjectContext
    private weak var window: UIWindow?

    // MARK: - Initialization

    // TODO: Update HeaderDoc.
    /**
     Creates a coordinator.

     - Parameters:
        - window: The app's key window.
        - mockingService: Indicates whether the app's UI shall be mocked.
     */
    init(window: UIWindow, context: NSManagedObjectContext, catalogueService: CatalogueService) {
        self.window = window
        self.context = context
        self.catalogueService = catalogueService
    }

    // MARK: - Methods

    // MARK: Coordinator protocol methods

    func start() {
        let view = MainFactory.makeMainView(context: context, catalogueService: catalogueService)
        let navigationView = NavigationView { view }
        let controller = UIHostingController(rootView: navigationView)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

}
