//
//  BookDetailsViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 21.2.2021.
//

import Combine
import Foundation

/// Provides presentation data for a book details.
@MainActor
protocol BookDetailsViewModel: ObservableObject {

    // MARK: - Properties

    /// The ready to present combined authors string.
    var authors: String { get }
    /// The book's description.
    var description: String { get }
    /// The book's image.
    var image: UniversalImage? { get }
    /// The book's rating.
    var rating: String? { get }
    /// The book's title.
    var title: String { get }

}

// MARK: -

/// The default provider of presentation data for a book details.
final class BookDetailsDefaultViewModel: BookDetailsViewModel {

    // MARK: - Properties

    // MARK: BookDetailsViewModel protocol properties

    let authors: String
    let description: String
    let rating: String?
    let title: String
    @Published
    var image: UniversalImage?

    // MARK: Private properties

    // FIXME: Don't store it.
    private let imageService: ImageService

    // MARK: - Initialization

    /// Creates the provider.
    /// - Parameters:
    ///   - authors: The authors string.
    ///   - title: The title string.
    ///   - description: The book's description.
    ///   - imageURL: The URL of the image.
    ///   - rating: The book's rating.
    ///   - imageService: The service that magically turns image URL into image.
    init(
        authors: String,
        title: String,
        description: String,
        imageURL: URL?,
        rating: String?,
        imageService: ImageService
    ) {
        self.authors = authors
        self.description = description
        self.title = title
        self.rating = rating
        self.imageService = imageService

        retrieveImage(from: imageURL, using: self.imageService)
    }

    // MARK: - Methods

    // MARK: Private methods

    private func retrieveImage(from url: URL?, using service: ImageService) {
        guard let url else {
            return
        }
        Task {
            let image = await service.getImage(from: url)
            Task { @MainActor in
                self.image = image
            }
        }
    }

}

#if DEBUG

// MARK: -

final class BookDetailsPreviewViewModel: BookDetailsViewModel {

    // MARK: - Properties

    // MARK: BookDetailsViewModel protocol properties

    let authors = "J.R.R. Tolkien"
    let description = "A sensitive hobbit unexpectedly saves the situation."
    let image = UniversalImage(systemName: "scribble.variable")
    let rating: String? = "1.23"
    let title = "The Lord of the Rings"

}

#endif
