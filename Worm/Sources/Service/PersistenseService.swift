//
//  PersistenseService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 4.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

// TODO: HeaderDoc.
protocol PersistenseService {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var favoriteBooks: [FavoriteBook] { get }

    // MARK: - Methods

    // TODO: HeaderDoc.
    func addToFavoriteBooks(_ id: String)
    // TODO: HeaderDoc.
    func removeFromFavoriteBooks(_ id: String)

}

// MARK: -

// TODO: HeaderDoc.
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

    // TODO: HeaderDoc.
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
