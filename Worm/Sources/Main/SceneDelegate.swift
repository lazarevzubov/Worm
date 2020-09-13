//
//  SceneDelegate.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Coordinator
import GoodreadsService
import UIKit

// TODO: Check design layers (draw diagram maybe).

/// Manages the life cycle of a scene.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    // MARK: UIWindowSceneDelegate protocol properties

    var window: UIWindow? {
        didSet {
            if let window = window {
                coordinator = AppCoordinator(window: window,
                                             catalogueService: catalogueService,
                                             favoritesService: favoritesService)
            }
        }
    }

    // MARK: Private properties

    private lazy var catalogueService: CatalogueService = {
        #if TEST
        return CatalogueMockService()
        #else
        return GoodreadsService(key: Settings.goodreadsAPIKey)
        #endif
    }()
    private var coordinator: Coordinator? {
        didSet { coordinator?.start() }
    }
    private lazy var favoritesService
        = FavoritesPersistenceService(persistenceContext: CoreData.shared.managedObjectContext)

    // MARK: - Methods

    // MARK: UIWindowSceneDelegate protocol methods

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
         CoreData.shared.saveContext()
    }

}
