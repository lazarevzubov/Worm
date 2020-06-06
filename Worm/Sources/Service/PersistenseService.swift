//
//  PersistenseService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 4.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

/// A service providing an interface to track and manipulate the list of favorite books.
protocol PersistenseService {

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

/// The favorite books service based on a Core Data persistent storage.
final class PersistenseCoreDataService: PersistenseService {

    // MARK: - Properties

    var favoriteBooks: [FavoriteBook] {
        // TODO: Find a way to eliminate force-unwrapping.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteBook.entity().name!)
        
        return (try? databaseContext.fetch(fetchRequest) as? [FavoriteBook]) ?? []
    }

    // MARK: Private properties

    private let databaseContext: NSManagedObjectContext

    // MARK: - Initialization

    /**
     Creates a service instance.
     - Parameter databaseContext: An object space to manipulate and track changes to the app's Core Data persistent storage.
     */
    init(databaseContext: NSManagedObjectContext) {
        self.databaseContext = databaseContext
    }

    // MARK: - Methods

    // MARK: PersistenseService protocol methods

    func addToFavoriteBooks(_ id: String) {
        let favoriteBook = NSManagedObject(entity: FavoriteBook.entity(), insertInto: databaseContext)
        favoriteBook.setValue(id, forKey: "id") // TODO: Find out how to do that properly.

        try? databaseContext.save()
    }

    func removeFromFavoriteBooks(_ id: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: FavoriteBook.entity().name!)
        let favoriteBooks = (try? databaseContext.fetch(fetchRequest) as? [FavoriteBook]) ?? []
        favoriteBooks.forEach {
            if $0.id == id {
                databaseContext.delete($0)
                try? databaseContext.save()

                return
            }
        }
    }

}
