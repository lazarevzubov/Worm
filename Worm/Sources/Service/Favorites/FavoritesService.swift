//
//  FavoritesService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 4.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation
import SwiftData

/// Manages a favorite books list.
protocol FavoritesService {

    // MARK: - Properties

    /// The list of IDs of books blocked from recommendations.
    var blockedBookIDs: Set<String> { get }
    // TODO: HeaderDoc.
    var blockedBookIDsPublisher: Published<Set<String>>.Publisher { get }
    /// The list of IDs of favorite books.
    var favoriteBookIDs: Set<String> { get }
    // TODO: HeaderDoc.
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { get }

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

    var blockedBookIDsPublisher: Published<Set<String>>.Publisher { $blockedBookIDs }
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { $favoriteBookIDs }
    @Published
    private(set) var blockedBookIDs = Set<String>()
    @Published
    private(set) var favoriteBookIDs = Set<String>()

    // MARK: Private properties

    private let container: ModelContainer
    private var blockedBooks: [BlockedBook] {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<BlockedBook>()

        return (try? context.fetch(descriptor)) ?? []
    }
    private var favoriteBooks: [FavoriteBook] {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<FavoriteBook>()

        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - Initialization

    /// Creates a service instance.
    /// - Parameter modelContainer: An object that manages an app’s schema and model storage configuration.
    init(modelContainer: ModelContainer) {
        container = modelContainer
        update()
    }

    // MARK: - Methods

    // MARK: FavoritesService protocol methods

    func addToBlockedBook(withID id: String) {
        do {
            let blockedBook = BlockedBook(id: id)

            let context = ModelContext(container)
            context.insert(blockedBook)
            try context.save()

            updateBlockedBooks()
        } catch {
            // TODO: Proper error handling.
            print("Could not save context: \(error)")
        }
    }

    func addToFavoritesBook(withID id: String) {
        do {
            let favoriteBook = FavoriteBook(id: id)

            let context = ModelContext(container)
            context.insert(favoriteBook)
            try context.save()

            updateFavoriteBooks()
        } catch {
            // TODO: Proper error handling.
            print("Could not save context: \(error)")
        }
    }

    func removeFromFavoriteBook(withID id: String) {
        do {
            try ModelContext(container).delete(model: FavoriteBook.self, where: #Predicate { $0.id == id })
            updateFavoriteBooks()
        } catch {
            // TODO: Proper error handling.
            print("Could not save context: \(error)")
        }
    }

    // MARK: Private methods

    private func update() {
        updateBlockedBooks()
        updateFavoriteBooks()
    }

    private func updateBlockedBooks() {
        blockedBookIDs = Set(blockedBooks.map { $0.id })
    }

    private func updateFavoriteBooks() {
        favoriteBookIDs = Set(favoriteBooks.map { $0.id })
    }

}
