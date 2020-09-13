//
//  AppCoordinator.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 19.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Coordinator
import CoreData
import GoodreadsService
import SwiftUI

/// Handles the navigation to and within the main screen of the app.
final class AppCoordinator: Coordinator {

    // MARK: - Properties

    // MARK: Private properties

    private let context: NSManagedObjectContext
    private weak var window: UIWindow?
    private lazy var catalogueService: CatalogueService = {
        #if TEST
        return CatalogueMockService()
        #else
        return GoodreadsService(key: Settings.goodreadsAPIKey)
        #endif
    }()
    private lazy var favoritesService: FavoritesService = FavoritesPersistenceService(persistenceContext: context)

    // MARK: - Initialization

    /**
     Creates a coordinator.
     - Parameters:
        - window: The app's key window.
        - context: An object space for manipulating and tracking changes to managed objects.
     */
    init(window: UIWindow, context: NSManagedObjectContext) {
        self.window = window
        self.context = context
    }

    // MARK: - Methods

    // MARK: Coordinator protocol methods

    func start() {
        let view = ViewFactory.makeMainView(context: context,
                                            catalogueService: catalogueService,
                                            favoritesService: favoritesService)
        let controller = UIHostingController(rootView: view)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }

}
