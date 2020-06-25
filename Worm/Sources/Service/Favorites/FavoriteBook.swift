//
//  FavoriteBook.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 19.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

/// A persisted object representing a favorite book.
class FavoriteBook: NSManagedObject {

    // Not final because it needs to be mocked within unit tests.
    // TODO: Find a way to avoid inheritance.

    // MARK: - Properties

    /// The entity name for a Core Data database.
    static let entityName = "FavoriteBook"
    /// Th book's ID.
    @NSManaged
    var id: String

}
