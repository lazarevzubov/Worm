//
//  CoreData.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 21.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

/// The app's Core Data database entry point.
final class CoreData {

    // MARK: - Properties

    /// The shared instance of the Core Data database.
    static let shared = CoreData()
    /// An object space for manipulating and tracking changes to managed objects.
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
#if TEST
        return makeInMemoryContext()
#else
        return persistentContainer.viewContext
#endif
    }()

    // MARK: Private properties

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Worm")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: Handle errors.
                fatalError("Unresolved error \(error), \(error.userInfo).")
            }
        }

        return container
    }()

    // MARK: - Initialization

    // MARK: Private initialization

    private init() { }

    // MARK: - Methods

    /// Saves the current state of the app's CoreData context.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: Handle errors.
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo).")
            }
        }
    }

    // MARK: Private methods

    private func makeInMemoryContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [.main])!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil)

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }

}
