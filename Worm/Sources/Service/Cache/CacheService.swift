//
//  CacheService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 4.3.2025.
//  Copyright © 2025 Nikita Lazarev-Zubov. All rights reserved.
//

/// Stores results of computations or distributed calls to provide them in a more efficient manner than repeating the initial call again.
protocol CacheService<Key, Entity>: Actor {

    /// The type of keys associated with stored objects, which are used to retrieve the stored value.
    associatedtype Key: Hashable
    /// The type of stored data.
    associatedtype Entity

    // MARK: - Properties

    /// The stored data, in no particular order.
    var storage: [Key: Entity] { get }

    // MARK: - Methods

    /// Inserts a new object to the storage.
    /// - Parameters:
    ///   - entity: The new object to store.
    ///   - key: The key, associated with the object.
    func insert(_ entity: Entity, for key: Key)

}

// MARK: -

/// Stores results of computations or distributed calls to provide them in a more efficient manner than repeating the initial call again.
///
/// Uses the in-memory kind of storage, which is nor persisted across the app launches.
actor CacheInMemoryService<Key: Hashable, Entity>: CacheService {

    // MARK: - Properties

    // MARK: CacheService protocol properties

    private(set) var storage = [Key : Entity]()

    // MARK: - Methods

    // MARK: CacheService protocol methods

    func insert(_ entity: Entity, for key: Key) {
        storage[key] = entity
    }

}
