//
//  FavoriteBook.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 19.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

/// A persisted object representing a favorite book.
class FavoriteBook: NSManagedObject, Entity { // Not final because it needs to be mocked within unit tests.

    // MARK: - Properties

    /// The book's ID.
    @NSManaged
    var id: String

    // MARK: Entity protocol properties

    static let entityName = "FavoriteBook"

}
