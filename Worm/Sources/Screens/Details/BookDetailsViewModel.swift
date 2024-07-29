//
//  BookDetailsViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 21.2.2021.
//

import Combine
import Foundation

/// Provides presentation data for a book details.
protocol BookDetailsViewModel: Sendable, ObservableObject {

    // MARK: - Properties

    /// The ready to present combined authors string.
    var authors: String { get }
    /// The book's description.
    var description: String { get }
    /// The book's image.
    var image: UniversalImage? { get }
    /// The book's title.
    var title: String { get }

}

// MARK: -

/// The default provider of presentation data for a book details.
final class BookDetailsDefaultViewModel: @unchecked Sendable, BookDetailsViewModel {

    // MARK: - Properties

    // MARK: BookDetailsViewModel protocol properties

    let authors: String
    let description: String
    let title: String
    @Published
    var image: UniversalImage?

    // MARK: Private properties

    private let imageService: ImageService

    // MARK: - Initialization

    /// Creates the provider.
    /// - Parameters:
    ///   - authors: The authors string.
    ///   - title: The title string.
    ///   - description: The book's description.
    ///   - imageURL: The URL of the image.
    ///   - imageService: The service that magically turns image URL into image.
    init(authors: String, title: String, description: String, imageURL: URL?, imageService: ImageService) {
        self.authors = authors
        self.description = description
        self.title = title
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
            await MainActor.run { self.image = image }
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
    let title = "The Lord of the Rings"

}

#endif
