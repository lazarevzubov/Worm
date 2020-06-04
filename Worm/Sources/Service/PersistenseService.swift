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

}
