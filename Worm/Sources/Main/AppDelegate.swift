//
//  AppDelegate.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import UIKit
import CoreData

/// Manages the life cycle of the app.
@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // TODO: Factor out CoreData managing.

    // MARK: - Properties

    // TODO: HeaderDoc.
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        #if TEST
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [.main])!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil)

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
        #else
        return persistentContainer.viewContext
        #endif
    }()
    // TODO: HeaderDoc.
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

    /// Saves the current state of the app's CoreData context.
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
