//
//  RatingViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.4.2025.
//

/// Presentation logic of a view, displaying a rating.
struct RatingViewModel {

    /// A single unit of the rating.
    enum RatingUnit {

        /// An empty unit.
        case empty
        /// A half empty unit.
        case halfEmpty
        /// A full unit.
        case full

    }

    // MARK: - Properties

    /// The rating.
    let rating: Double
    /// Rating split into units.
    let units: [RatingUnit]

    // MARK: - Initialization

    /// Creates an object, representing presentation logic of a view, displaying a rating.
    /// - Parameters:
    ///   - rating: The rating to display.
    ///   - maxRating: The maximum rating.
    init(rating: Double, maxRating: Int = 5) {
        self.rating = rating
        units = (0..<maxRating).map {
            let threshold = Double($0)
            return if rating >= threshold + 1 {
                .full
            } else if rating >= threshold + 0.5 {
                .halfEmpty
            } else {
                .empty
            }
        }
    }

}
