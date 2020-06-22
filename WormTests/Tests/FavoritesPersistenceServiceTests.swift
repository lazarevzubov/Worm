//
//  FavoritesPersistenceServiceTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 19.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
@testable
import Worm
import XCTest

final class FavoritesPersistenceServiceTests: XCTestCase {

    // MARK: -

    override func tearDown() {
        super.tearDown()

        let managedObjectContext = CoreData.shared.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FavoriteBook.entityName)
        let objects = try! managedObjectContext.fetch(fetchRequest) as! [FavoriteBook]
        for object in objects {
            managedObjectContext.delete(object)
        }
    }

    func testFavoriteBooksInitiallyEmpty() {
        let context = CoreData.shared.managedObjectContext
        let service = FavoritesPersistenceService(persistenceContext: context)

        XCTAssertTrue(service.favoriteBooks.isEmpty)
    }

    func testAdd() {
        let context = CoreData.shared.managedObjectContext
        let service = FavoritesPersistenceService(persistenceContext: context)

        let id = "1"
        service.addToFavoriteBooks(id)

        let ids = service.favoriteBooks.map { $0.id }
        XCTAssertEqual(ids, [id])
    }

    func testAddingSameObjectIgnored() {
        // Core Data constraints don't work for in-memory storage.
    }

    func testRemove() {
        let context = CoreData.shared.managedObjectContext
        let service = FavoritesPersistenceService(persistenceContext: context)

        let id = "1"
        
        service.addToFavoriteBooks(id)
        var ids = service.favoriteBooks.map { $0.id }
        XCTAssertEqual(ids, [id])

        service.removeFromFavoriteBooks(id)
        ids = service.favoriteBooks.map { $0.id }
        XCTAssertEqual(ids, [])
    }

}
