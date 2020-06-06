//
//  MainCoordinatorTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 20.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

@testable
import Worm
import XCTest

final class MainCoordinatorTests: XCTestCase {

    // MARK: - Methods

    func testWindowRetain() {
        var window = UIWindow()
        weak var weakWindow = window

        _ = AppCoordinator(window: window)
        XCTAssertNotNil(weakWindow)

        window = UIWindow()
        XCTAssertNil(weakWindow)
    }

    func testWindowHasRootViewControllerAfterStart() {
        let window = UIWindow()
        let coordinator = AppCoordinator(window: window)
        XCTAssertNil(window.rootViewController)

        coordinator.start()
        XCTAssertNotNil(window.rootViewController)
    }

    func testWindowIsKeyAfterStart() {
        let window = UIWindow()
        let coordinator = AppCoordinator(window: window)
        XCTAssertFalse(window.isKeyWindow)

        coordinator.start()
        XCTAssertTrue(window.isKeyWindow)
    }

}
