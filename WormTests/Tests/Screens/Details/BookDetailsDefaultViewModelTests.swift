//
//  BookDetailsDefaultViewModelTests.swift
//  WormTests
//
//  Created by Nikita Lazarev-Zubov on 14.3.2024.
//

@preconcurrency
import Combine
import CoreGraphics
import Foundation
import Testing
@testable
import Worm

struct BookDetailsDefaultViewModelTests {

    // MARK: - Methods

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
