//
//  FavoriteBook.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 19.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData

// TODO: HeaderDoc.
class FavoriteBook: NSManagedObject {

    // Not final because it needs to be mocked within unit tests.
    // TODO: Find a way to avoid inheritance.

    // MARK: - Properties

    // TODO: HeaderDoc.
    static let entityName = "FavoriteBook"
    // TODO: HeaderDoc.
    @NSManaged
    var id: String

}
