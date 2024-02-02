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

    /// The current list of blocked from recommendations books.
    var blockedBooks: [BlockedBook] { get }
    /// The current list of favorite books.
    var favoriteBooks: [FavoriteBook] { get }

    // MARK: - Methods

    /**
     Blocks a book from recommendations..
     - Parameter id: The ID of the book to block.
     */
    func addToBlockedBooks(_ id: String)
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

    var blockedBooks: [BlockedBook] { fetched(BlockedBook.self) }
    var favoriteBooks: [FavoriteBook] { fetched(FavoriteBook.self) }

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

    func addToBlockedBooks(_ id: String) {
        add(id, toManagedType: BlockedBook.self)
    }

    func addToFavoriteBooks(_ id: String) {
        add(id, toManagedType: FavoriteBook.self)
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

    // MARK: Private methods

    private func fetched<SpecificEntity: Entity>(_ entity: SpecificEntity.Type) -> [SpecificEntity] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.entityName)
        return (try? persistenceContext.fetch(fetchRequest) as? [SpecificEntity]) ?? []
    }

    private func add(_ id: String, toManagedType managedType: NSManagedObject.Type) {
        let favoriteBook = NSManagedObject(entity: managedType.entity(), insertInto: persistenceContext)
        favoriteBook.setValue(id, forKey: "id") // TODO: Find out how to do that properly.

        saveContextAndNotifyObservers()
    }

    private func saveContextAndNotifyObservers() {
        do {
            try persistenceContext.save()
            objectWillChange.send()
        } catch {
            // TODO: Handle errors.
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo).")
        }
    }

}
