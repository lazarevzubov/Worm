//
//  CoreDataTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 16.9.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

@testable
import Worm
import XCTest

final class CoreDataTests: XCTestCase {

    // MARK: - Methods

    func testSingleton() {
        XCTAssertTrue(CoreData.shared === CoreData.shared)
    }

}
