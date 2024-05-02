//
//  BookDetailsViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 21.2.2021.
//

import UIKit

/// Provides presentation data for a book details.
protocol BookDetailsViewModel: Sendable, ObservableObject {

    // MARK: - Properties

    /// The ready to present combined authors string.
    var authors: String { get }
    /// The book's image.
    var image: UIImage? { get }
    /// The book's title.
    var title: String { get }

}

// MARK: -

/// The default provider of presentation data for a book details.
final class BookDetailsDefaultViewModel: @unchecked Sendable, BookDetailsViewModel {

    // MARK: - Properties

    // MARK: BookDetailsViewModel protocol properties

    let authors: String
    let title: String
    @Published
    private(set) var image: UIImage?

    // MARK: Private properties

    private let imageService: ImageService

    // MARK: - Initialization

    /// Creates the provider.
    /// - Parameters:
    ///   - authors: The authors string.
    ///   - title: The title string.
    ///   - imageURL: The URL of the image.
    ///   - imageService: The service that magically turns image URL into image.
    init(authors: String, title: String, imageURL: URL?, imageService: ImageService) {
        self.authors = authors
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
    let image = UIImage(systemName: "scribble.variable")
    let title = "The Lord of the Rings"

}

#endif
