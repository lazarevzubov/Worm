//
//  MainCoordinatorTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 20.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
@testable
import Worm
import XCTest

final class MainCoordinatorTests: XCTestCase {

    // MARK: - Methods

    func testWindowRetain() {
        var window = UIWindow()
        weak var weakWindow = window

        _ = AppCoordinator(window: window, context: PersistenceStubContext())
        XCTAssertNotNil(weakWindow)

        window = UIWindow()
        XCTAssertNil(weakWindow)
    }

    func testWindowHasRootViewControllerAfterStart() {
        let window = UIWindow()
        let coordinator = AppCoordinator(window: window, context: PersistenceStubContext())
        XCTAssertNil(window.rootViewController)

        coordinator.start()
        XCTAssertNotNil(window.rootViewController)
    }

    func testWindowIsKeyAfterStart() {
        let window = UIWindow()
        let coordinator = AppCoordinator(window: window, context: PersistenceStubContext())
        XCTAssertFalse(window.isKeyWindow)

        coordinator.start()
        XCTAssertTrue(window.isKeyWindow)
    }

}

// MARK: -

private struct PersistenceStubContext: PersistenceContext {

    // MARK: - Methods

    // MARK: PersistenceContext protocol methods

    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        return []
    }

    func delete(_ object: NSManagedObject) {
        // Do nothing.
    }

    func save() throws {
        // Do nothing.
    }

}
