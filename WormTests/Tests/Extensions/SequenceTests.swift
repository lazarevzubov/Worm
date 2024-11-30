//
//  SequenceTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 13.3.2024.
//

import Testing
@testable
import Worm

struct SequenceTests {

    // MARK: - Methods

    func stableSorted_sorts() {
        let items = [
            Item(value: 3),
            Item(value: 2),
            Item(value: 2),
            Item(value: 1)
        ]

        let sortedItems = items.stableSorted { $0.value < $1.value }
        #expect(
            sortedItems.map { $0.value } == [1,
                                             2,
                                             2,
                                             3],
            "Sorting produced the unexpected result."
        )
    }

    func stableSorted_stable() {
        let item1 = Item(value: 1)
        let item2 = Item(value: 2)
        let item3 = Item(value: 2)
        let item4 = Item(value: 3)
        let items = [
            item4,
            item2,
            item3,
            item1
        ]

        let sortedItems = items.stableSorted { $0.value < $1.value }

        #expect(sortedItems[1] === item2, "Sorting changed positions of equivalent items.")
        #expect(sortedItems[2] === item3, "Sorting changed positions of equivalent items.")
    }

    private final class Item {

        let value: Int

        init(value: Int) {
            self.value = value
        }

    }

}
