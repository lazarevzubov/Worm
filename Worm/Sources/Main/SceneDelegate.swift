//
//  SceneDelegate.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Coordinator
import CoreData
import SwiftUI
import UIKit

/// Manages the life cycle of a scene.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    // MARK: UIWindowSceneDelegate protocol properties

    var window: UIWindow? {
        didSet {
            if let window = window {
                coordinator = AppCoordinator(window: window, context: viewContext, mockingService: testing)
            }
        }
    }

    // MARK: Private properties

    private var viewContext: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            // TODO: Handle error properly.
            fatalError("Impossible state: shared UIApplication delegate is not an AppDelegate.")
        }
        return appDelegate.persistentContainer.viewContext
    }
    private var coordinator: Coordinator? {
        didSet { coordinator?.start() }
    }
    private var testing: Bool {
        #if TEST
        return true
        #else
        return false
        #endif
    }

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
        saveContext()
    }

    // MARK: Private properties

    private func saveContext() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
