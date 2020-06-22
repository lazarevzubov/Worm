//
//  CoreData.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 21.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

// TODO: HeaderDoc.
final class CoreData {

    // MARK: - Properties

    // TODO: HeaderDoc.
    static let shared = CoreData()
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

    // MARK: Private properties

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Worm")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: Handle errors.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    // MARK: - Initialization

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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
