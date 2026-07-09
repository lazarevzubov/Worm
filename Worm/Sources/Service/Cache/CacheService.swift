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

    // MARK: - Methods

    /// Returns the stored value for the given key, if present.
    /// - Parameter key: The key, associated with the object.
    /// - Returns: The stored object, or `nil` if there's none stored for the given key.
    func value(for key: Key) -> Entity?
    /// Inserts a new object to the storage.
    /// - Parameters:
    ///   - entity: The new object to store.
    ///   - key: The key, associated with the object.
    func insert(_ entity: Entity, for key: Key)

}

// MARK: -

/// Stores results of computations or distributed calls to provide them in a more efficient manner than repeating the
///   initial call again.
///
/// Uses the in-memory kind of storage, which is nor persisted across the app launches. Once the number of stored
///   entities reaches `capacity`, the LRU one is evicted to make room for a new one.
actor CacheInMemoryService<Key: Hashable, Entity>: CacheService {

    // MARK: - Properties

    // MARK: Private properties

    private let capacity: Int
    private var recencyOrder = [Key]()
    private var storage = [Key: Entity]()

    // MARK: - Initialization

    /// Creates a cache service, backed by an in-memory storage.
    /// - Parameter capacity: The maximum number of entities to store at once, before the least recently used one gets
    ///   evicted.
    init(capacity: Int = 200) {
        self.capacity = capacity
    }

    // MARK: - Methods

    // MARK: CacheService protocol methods

    func value(for key: Key) -> Entity? {
        guard let entity = storage[key] else {
            return nil
        }
        markUsed(key)

        return entity
    }

    func insert(_ entity: Entity, for key: Key) {
        storage[key] = entity
        markUsed(key)

        if storage.count > capacity,
        let leastRecentlyUsed = recencyOrder.first {
            storage.removeValue(forKey: leastRecentlyUsed)
            recencyOrder.removeFirst()
        }
    }

    // MARK: Private methods

    private func markUsed(_ key: Key) {
        recencyOrder.removeAll { $0 == key }
        recencyOrder.append(key)
    }

}
