//
//  BlockedBook.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

/// A persisted object representing a blocked from recommendations book.
class BlockedBook: NSManagedObject, Entity { // Not final because it needs to be mocked within unit tests.

    // MARK: - Properties

    /// The book's ID.
    @NSManaged
    var id: String

    // MARK: Entity protocol properties

    static let entityName = "BlockedBook"

}
