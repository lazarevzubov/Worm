//
//  FavoritesService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 4.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

/// A service providing an interface to track and manipulate the list of favorite books.
protocol FavoritesService {

    // MARK: - Properties

    /// A list of favorite books.
    var favoriteBooks: [FavoriteBook] { get }

    // MARK: - Methods

    /**
     Adds a new favorite book.
     - Parameter id: The ID of the book to add to favorites.
     */
    func addToFavoriteBooks(_ id: String)
    /**
    Removes a book from favorites.
    - Parameter id: The ID of the book to remove from favorites.
    */
    func removeFromFavoriteBooks(_ id: String)

}

// MARK: -

// TODO: HeaderDoc.
protocol PersistenceContext {

    // MARK: - Methods

    // TODO: HeaderDoc.
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T: NSFetchRequestResult
    // TODO: HeaderDoc.
    func delete(_ object: NSManagedObject)
    // TODO: HeaderDoc.
    func save() throws
}

// MARK: - PersistenceContext

extension NSManagedObjectContext: PersistenceContext { }

// MARK: -

extension NSManagedObject {

    // MARK: - Initialization

    // TODO: HeaderDoc.
    convenience init(entity: NSEntityDescription, insertInto context: PersistenceContext) {
        self.init(entity: entity, insertInto: context as? NSManagedObjectContext)
    }

}

// MARK: -

/// The favorite books service based on a Core Data persistent storage.
final class FavoritesPersistenceService: FavoritesService {

    // MARK: - Properties

    var favoriteBooks: [FavoriteBook] {
        // TODO: Find a way to eliminate force-unwrapping.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteBook.entity().name!)
        
        return (try? persistenceContext.fetch(fetchRequest) as? [FavoriteBook]) ?? []
    }

    // MARK: Private properties

    private let persistenceContext: PersistenceContext

    // MARK: - Initialization

    /**
     Creates a service instance.
     - Parameter databaseContext: An object space to manipulate and track changes to the app's Core Data persistent storage.
     */
    init(persistenceContext: PersistenceContext) {
        self.persistenceContext = persistenceContext
    }

    // MARK: - Methods

    // MARK: PersistenseService protocol methods

    func addToFavoriteBooks(_ id: String) {
        let favoriteBook = NSManagedObject(entity: FavoriteBook.entity(), insertInto: persistenceContext)
        favoriteBook.setValue(id, forKey: "id") // TODO: Find out how to do that properly.

        try? persistenceContext.save()
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
