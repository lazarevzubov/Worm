//
//  MainDefaultModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 17.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

@testable
import Worm
import XCTest

final class MainDefaultModelTests: XCTestCase {

    // MARK: - Methods

    func testBooksInitiallyEmpty() {
        let model = MainDefaultModel()
        XCTAssertTrue(model.books.isEmpty)
    }

}
