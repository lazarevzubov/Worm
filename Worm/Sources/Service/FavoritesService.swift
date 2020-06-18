//
//  FavoritesService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 4.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

/// The favorite books service based on a Core Data persistent storage.
final class FavoritesService {

    // MARK: - Properties

    var favoriteBooks: [FavoriteBook] {
        // TODO: Find a way to eliminate force-unwrapping.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteBook.entity().name!)

        return (try? persistenceContext.fetch(fetchRequest) as? [FavoriteBook]) ?? []
    }

    // MARK: Private properties

    private let persistenceContext: NSManagedObjectContext

    // MARK: - Initialization

    // TODO: Update HeaderDoc.
    /**
     Creates a service instance.
     - Parameter databaseContext: An object space to manipulate and track changes to the app's Core Data persistent storage.
     */
    init(persistenceContext: NSManagedObjectContext) {
        self.persistenceContext = persistenceContext
    }

    // MARK: - Methods

    // MARK: PersistenseService protocol methods

    func addToFavoriteBooks(_ id: String) {
        let favoriteBook = NSManagedObject(entity: FavoriteBook.entity(), insertInto: persistenceContext)
        favoriteBook.setValue(id, forKey: "id") // TODO: Find out how to do that properly.

        try! persistenceContext.save()
    }

    func removeFromFavoriteBooks(_ id: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteBook.entity().name!)
        let favoriteBooks = (try? persistenceContext.fetch(fetchRequest) as? [FavoriteBook]) ?? []
        favoriteBooks.forEach {
            if $0.id == id {
                persistenceContext.delete($0)
                try? persistenceContext.save()

                return
            }
        }
    }

}
