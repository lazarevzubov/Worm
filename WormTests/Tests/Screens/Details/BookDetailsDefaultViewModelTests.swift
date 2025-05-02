//
//  BookDetailsDefaultViewModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 14.3.2024.
//

@preconcurrency
import Combine
import Foundation
import Testing
@testable
import Worm

struct BookDetailsDefaultViewModelTests {

    // MARK: - Methods

    @MainActor
    @Test(.timeLimit(.minutes(1)))
    func imageRetrieved() async throws {
        let url = URL(string: "https://example.com")!
        let vm: BookDetailsDefaultViewModel = BookDetailsDefaultViewModel(
            authors: "Authors",
            title: "Title",
            description: "Desc",
            imageURL: url,
            rating: nil,
            imageService: ImageMockService(images: [url : UniversalImage()])
        )

        var images = vm.$image.dropFirst().values.makeAsyncIterator()
        await #expect(images.next() != nil, "Retrieved image should not be nil.")
    }

    @MainActor
    @Test
    func createsRatingViewModel_withRating_asProvided() {
        let rating = 1.23
        let vm: any BookDetailsViewModel = BookDetailsDefaultViewModel(
            authors: "Authors",
            title: "Title",
            description: "Description",
            imageURL: nil,
            rating: rating,
            imageService: ImageMockService()
        )

        #expect(vm.ratingViewModel?.rating == 1.23, "Rating should be the same as provided.")
    }

}
