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
        let vm = BookDetailsDefaultViewModel(authors: "Authors",
                                             title: "Title",
                                             imageURL: URL(string: "https://example.com"),
                                             imageService: ImageMockService())

        let expectation = XCTestExpectation(description: "Image retrieved")

        var cancellables = Set<AnyCancellable>()
        vm
            .image
            .publisher
            .sink {
                XCTAssertNotNil($0, "Retrieved image is nil.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)

        cancellables.forEach { $0.cancel() }
    }

    // MARK: -

    private struct ImageMockService: ImageService {

        // MARK: - Methods

        // MARK: ImageService protocol methods

        func getImage(from url: URL) async -> UIImage? {
            UIImage()
        }

    }

}
