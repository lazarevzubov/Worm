//
//  BookDetailsDefaultViewModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 14.3.2024.
//

import Combine
@testable
import Worm
import XCTest

final class BookDetailsDefaultViewModelTests: XCTestCase {

    // MARK: - Methods

    func testImageRetrieved() throws {
        let url = URL(string: "https://example.com")!
        let vm: BookDetailsDefaultViewModel = BookDetailsDefaultViewModel(
            authors: "Authors",
            title: "Title",
            description: "Desc",
            imageURL: url,
            imageService: ImageMockService(images: [url : UniversalImage()])
        )

        let expectation = XCTestExpectation(description: "Image retrieved")

        var cancellables = Set<AnyCancellable>()
        vm
            .$image
            .dropFirst()
            .sink { _ in
                // Do nothing on completion.
            } receiveValue: {
                XCTAssertNotNil($0, "Retrieved image is nil.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

}
