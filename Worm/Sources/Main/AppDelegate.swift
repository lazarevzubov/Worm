//
//  AppDelegate.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import UIKit
import CoreData

// TODO: HeaderDoc.
@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // TODO: Factor out CoreData managing.

    // MARK: - Properties

    // MARK: Private properties

    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Worm")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: Handle errors.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    // MARK: - Methods

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: Handle errors.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: UIApplicationDelegate protocol methods

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

}
