//
//  BookDetailsDefaultViewModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 14.3.2024.
//

import Combine
import Foundation
import Testing
@testable
import Worm

struct BookDetailsDefaultViewModelTests {

    // MARK: - Methods

    @Test(.timeLimit(.minutes(1)))
    func imageRetrieved() async throws {
        let url = URL(string: "https://example.com")!
        let vm: BookDetailsDefaultViewModel = BookDetailsDefaultViewModel(
            authors: "Authors",
            title: "Title",
            description: "Desc",
            imageURL: url,
            imageService: ImageMockService(images: [url : UniversalImage()])
        )

        var images = vm.$image.dropFirst().values.makeAsyncIterator()
        await #expect(images.next() != nil, "Retrieved image should not be nil.")
    }

}
