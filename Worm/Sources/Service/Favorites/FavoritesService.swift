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
protocol FavoritesService: Actor {

    // MARK: - Properties

    /// The list of IDs of favorite books.
    var favoriteBookIDs: Set<String> { get }
    /// The publisher of books to the list of IDs of favorite books.
    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { get }

    // MARK: - Methods

    /// Adds a favorite book to the current list.
    /// - Parameter id: The ID of the book to be added.
    /// - Throws: An error if the change couldn't be persisted.
    func addToFavoritesBook(withID id: String) throws
    /// Removes a favorite book from the current list.
    /// - Parameter id: The ID of the book to be removed.
    /// - Throws: An error if the change couldn't be persisted.
    func removeFromFavoriteBook(withID id: String) throws

}

// MARK: -

/// The favorite books service based on a Core Data persistent storage.
actor FavoritesPersistenceService: FavoritesService {

    // MARK: - Properties

    // MARK: FavoritesService protocol properties

    var favoriteBookIDsPublisher: Published<Set<String>>.Publisher { $favoriteBookIDs }
    @Published
    private(set) var favoriteBookIDs = Set<String>()

    // MARK: Private properties

    private let container: ModelContainer
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
        Task { [weak self] in
            await self?.updateFavoriteBooks()
        }
    }

    // MARK: - Methods

    // MARK: FavoritesService protocol methods

    func addToFavoritesBook(withID id: String) throws {
        let favoriteBook = FavoriteBook(id: id)

        let context = ModelContext(container)
        context.insert(favoriteBook)
        try context.save()

        updateFavoriteBooks()
    }

    func removeFromFavoriteBook(withID id: String) throws {
        let context = ModelContext(container)
        try context.delete(model: FavoriteBook.self, where: #Predicate { $0.id == id })
        try context.save()

        updateFavoriteBooks()
    }

    // MARK: Private methods

    private func updateFavoriteBooks() {
        favoriteBookIDs = Set(favoriteBooks.map { $0.id })
    }

}
