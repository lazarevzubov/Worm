//
//  SequenceTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 13.3.2024.
//

@testable
import Worm
import XCTest

final class SequenceTests: XCTestCase {

    // MARK: - Methods

    func testStableSorted_sorts() throws {
        let items = [Item(value: 3),
                     Item(value: 2),
                     Item(value: 2),
                     Item(value: 1)]

        let sortedItems = items.stableSorted { $0.value < $1.value }
        XCTAssertEqual(sortedItems.map { $0.value },
                       [1,
                        2,
                        2,
                        3],
                       "Sorting produced the unexpected result.")
    }

    func testStableSorted_stable() throws {
        let item1 = Item(value: 1)
        let item2 = Item(value: 2)
        let item3 = Item(value: 2)
        let item4 = Item(value: 3)
        let items = [item4,
                     item2,
                     item3,
                     item1]

        let sortedItems = items.stableSorted { $0.value < $1.value }

        XCTAssertTrue(sortedItems[1] === item2, "Sorting changed positions of equivalent items.")
        XCTAssertTrue(sortedItems[2] === item3, "Sorting changed positions of equivalent items.")
    }

    private final class Item {

        let value: Int

        init(value: Int) {
            self.value = value
        }

    }

}
