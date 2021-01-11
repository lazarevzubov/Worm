//
//  FavoritesService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 4.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import CoreData

/// Manages a favorite books list.
protocol FavoritesService: ObservableObject {

    // MARK: - Properties

    /// The current list of favortite books.
    var favoriteBooks: [FavoriteBook] { get }

    // MARK: - Methods

    /**
     Adds a favorite book to the current list.
     - Parameter id: The ID of the book to be added.
     */
    func addToFavoriteBooks(_ id: String)
    /**
     Removes a favorite book from the current list.
     - Parameter id: The ID of the book to be removed.
     */
    func removeFromFavoriteBooks(_ id: String)

}

// MARK: -

/// The favorite books service based on a Core Data persistent storage.
final class FavoritesPersistenceService: FavoritesService {

    // MARK: - Properties

    // MARK: FavoritesService protocol properties

    var favoriteBooks: [FavoriteBook] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteBook.entityName)
        return (try? persistenceContext.fetch(fetchRequest) as? [FavoriteBook]) ?? []
    }

    // MARK: Private properties

    private let persistenceContext: NSManagedObjectContext

    // MARK: - Initialization

    /**
     Creates a service instance.
     - Parameter persistenceContext: An object space to manipulate and track changes to the app's Core Data persistent storage.
     */
    init(persistenceContext: NSManagedObjectContext) {
        self.persistenceContext = persistenceContext
    }

    // MARK: - Methods

    // MARK: FavoritesService protocol methods

    func addToFavoriteBooks(_ id: String) {
        let favoriteBook = NSManagedObject(entity: FavoriteBook.entity(), insertInto: persistenceContext)
        favoriteBook.setValue(id, forKey: "id") // TODO: Find out how to do that properly.

        do {
            try persistenceContext.save()
            objectWillChange.send()
        } catch {
            // TODO: Handle errors.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo).")
        }
    }

    func removeFromFavoriteBooks(_ id: String) {
        favoriteBooks.forEach {
            if $0.id == id {
                persistenceContext.delete($0)
                try? persistenceContext.save()

                objectWillChange.send()

                return
            }
        }
    }

}
