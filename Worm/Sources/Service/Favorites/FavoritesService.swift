//
//  FavoritesService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 4.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import SwiftData
import SwiftUI

/// Manages a favorite books list.
protocol FavoritesService: ObservableObject {

    // MARK: - Properties

    /// The list of IDs of books blocked from recommendations.
    var blockedBookIDs: [String] { get }
    /// The list of IDs of favorite books.
    var favoriteBookIDs: [String] { get }

    // MARK: - Methods

    /// Blocks a book from recommendations.
    /// - Parameter id: The ID of the book to block.
    func addToBlockedBook(withID id: String)
    /// Adds a favorite book to the current list.
    /// - Parameter id: The ID of the book to be added.
    func addToFavoritesBook(withID id: String)
    /// Removes a favorite book from the current list.
    /// - Parameter id: The ID of the book to be removed.
    func removeFromFavoriteBook(withID id: String)

}

// MARK: -

/// The favorite books service based on a Core Data persistent storage.
final class FavoritesPersistenceService: FavoritesService {

    // MARK: - Properties

    // MARK: FavoritesService protocol properties

    var blockedBookIDs: [String] {
        blockedBooks.map { $0.id }
    }
    var favoriteBookIDs: [String] {
        favoriteBooks.map { $0.id }
    }

    // MARK: Private properties

    private var blockedBooks: [BlockedBook] {
        let descriptor = FetchDescriptor<BlockedBook>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    var favoriteBooks: [FavoriteBook] {
        let descriptor = FetchDescriptor<FavoriteBook>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    private let modelContext: ModelContext

    // MARK: - Initialization

    /// Creates a service instance.
    /// - Parameter modelContainer: An object that manages an app’s schema and model storage configuration.
    init(modelContainer: ModelContainer) {
        self.modelContext = ModelContext(modelContainer)
    }

    // MARK: - Methods

    // MARK: FavoritesService protocol methods

    func addToBlockedBook(withID id: String) {
        do {
            let blockedBook = BlockedBook(id: id)

            modelContext.insert(blockedBook)
            try modelContext.save()

            objectWillChange.send()
        } catch {
            // TODO: Proper error handling.
            print("Could not save context: \(error)")
        }
    }

    func addToFavoritesBook(withID id: String) {
        do {
            let favoriteBook = FavoriteBook(id: id)

            modelContext.insert(favoriteBook)
            try modelContext.save()

            objectWillChange.send()
        } catch {
            // TODO: Proper error handling.
            print("Could not save context: \(error)")
        }
    }

    func removeFromFavoriteBook(withID id: String) {
        favoriteBooks.forEach {
            if $0.id == id {
                modelContext.delete($0)
                objectWillChange.send()

                return
            }
        }
    }

}
