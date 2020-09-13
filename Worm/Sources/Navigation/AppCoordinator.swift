//
//  AppCoordinator.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 19.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Coordinator
import SwiftUI

/// Handles the navigation to and within the main screen of the app.
final class AppCoordinator: Coordinator {

    // MARK: - Properties

    // MARK: Private properties

    private let catalogueService: CatalogueService
    private let favoritesService: FavoritesService
    private weak var window: UIWindow?

    // MARK: - Initialization

    // TODO: Update HeaderDoc.
    /**
     Creates a coordinator.
     - Parameters:
        - window: The app's key window.
        - context: An object space for manipulating and tracking changes to managed objects.
     */
    init(window: UIWindow, catalogueService: CatalogueService, favoritesService: FavoritesService) {
        self.window = window
        self.catalogueService = catalogueService
        self.favoritesService = favoritesService
    }

    // MARK: - Methods

    // MARK: Coordinator protocol methods

    func start() {
        let view = ViewFactory.makeMainView(catalogueService: catalogueService, favoritesService: favoritesService)
        let controller = UIHostingController(rootView: view)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

}
