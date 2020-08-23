//
//  AppCoordinatorTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 20.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import CoreData
@testable
import Worm
import XCTest

final class AppCoordinatorTests: XCTestCase {

    // MARK: - Methods

    func testWindowRetain() {
        var window = UIWindow()
        weak var weakWindow = window

        _ = AppCoordinator(window: window,
                           context: CoreData.shared.managedObjectContext)
        XCTAssertNotNil(weakWindow)

        window = UIWindow()
        XCTAssertNil(weakWindow)
    }

    func testWindowHasRootViewControllerAfterStart() {
        let window = UIWindow()
        let coordinator = AppCoordinator(window: window,
                                         context: CoreData.shared.managedObjectContext)
        XCTAssertNil(window.rootViewController)

        coordinator.start()
        XCTAssertNotNil(window.rootViewController)
    }

    func testWindowIsKeyAfterStart() {
        let window = UIWindow()
        let coordinator = AppCoordinator(window: window,
                                         context: CoreData.shared.managedObjectContext)
        XCTAssertFalse(window.isKeyWindow)

        coordinator.start()
        XCTAssertTrue(window.isKeyWindow)
    }

}
