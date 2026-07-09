//
//  CacheInMemoryServiceTests.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 8.7.2026.
//

import Testing
@testable
import Worm

struct CacheInMemoryServiceTests {

    // MARK: - Methods

    @Test
    func value_nil_whenNotInserted() async {
        let cache = CacheInMemoryService<String, Int>()
        await #expect(cache.value(for: "1") == nil)
    }

    @Test
    func value_returnsInsertedEntity() async {
        let cache = CacheInMemoryService<String, Int>()
        await cache.insert(1, for: "1")

        await #expect(cache.value(for: "1") == 1)
    }

    @Test
    func insert_evictsLeastRecentlyUsed_whenOverCapacity() async {
        let cache = CacheInMemoryService<String, Int>(capacity: 2)

        await cache.insert(1, for: "1")
        await cache.insert(2, for: "2")
        await cache.insert(3, for: "3")

        await #expect(cache.value(for: "1") == nil, "The least recently used entity should've been evicted.")
        await #expect(cache.value(for: "2") == 2)
        await #expect(cache.value(for: "3") == 3)
    }

    @Test
    func value_refreshesRecency_protectingFromEviction() async {
        let cache = CacheInMemoryService<String, Int>(capacity: 2)

        await cache.insert(1, for: "1")
        await cache.insert(2, for: "2")

        _ = await cache.value(for: "1") // Marks "1" as more recently used than "2".
        await cache.insert(3, for: "3")

        await #expect(cache.value(for: "2") == nil, "\"2\" was the least recently used and should've been evicted.")
        await #expect(cache.value(for: "1") == 1, "\"1\" was accessed after \"2\" and should've been kept.")
        await #expect(cache.value(for: "3") == 3)
    }

}
