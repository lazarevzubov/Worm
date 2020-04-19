//
//  SceneDelegate.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Coordinator
import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow? {
        didSet {
            if let window = window {
                coordinator = MainCoordinator(window: window)
            }
        }
    }

    // MARK: Private properties

    private var coordinator: Coordinator? {
        didSet { coordinator?.start() }
    }

    // MARK: - Methods

    // MARK: UIWindowSceneDelegate protocol methods

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            // fatalError("Impossible state: shared UIApplication delegate is not an AppDelegate.")
        // }
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        // let contentView = ContentView().environment(\.managedObjectContext, context)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
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
