//
//  BlockedBooksViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 9.8.2026.
//  Copyright © 2026 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine

/// Object responsible for the Blocked screen presentation logic.
@MainActor
protocol BlockedBooksViewModel: BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

    /// A list of view models representing items on the Blocked screen.
    var blockedBooks: [BookViewModel] { get }
    /// Whether an error alert about a failed save should be shown.
    var errorDisplayed: Bool { get set }

    // MARK: - Methods

    /// Removes a book from the blocked list.
    /// - Parameter book: The book to unblock.
    func unblockBook(_ book: BookViewModel)

}

// MARK: -

/// The default implementation of the Blocked screen view model.
final class BlockedBooksDefaultViewModel: BlockedBooksViewModel {

    // MARK: - Properties

    // MARK: BlockedBooksViewModel protocol properties

    @Published
    private(set) var blockedBooks = [BookViewModel]()
    @Published
    var errorDisplayed = false

    // MARK: Private properties

    private let imageService: ImageService
    private let model: any BlockedBooksModel
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Creates a view model object.
    /// - Parameters:
    ///   - model: Data providing object.
    ///   - imageService: The services that turns image URLs into images themselves.
    init(model: any BlockedBooksModel, imageService: ImageService) {
        self.model = model
        self.imageService = imageService

        Task { [weak self] in
            await self?.bind(model: model)
        }
    }

    // MARK: - Methods

    // MARK: BlockedBooksViewModel protocol methods

    func unblockBook(_ book: BookViewModel) {
        Task { @MainActor [weak self] in
            do {
                try await self?.model.unblockBook(withID: book.id)
            } catch {
                self?.errorDisplayed = true
            }
        }
    }

    func makeDetailsViewModel(for book: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsDefaultViewModel(
            authors: book.authors,
            title: book.title,
            description: book.description,
            imageURL: book.imageURL,
            rating: book.rating,
            imageService: imageService
        )
    }

    // MARK: Private methods

    private func bind(model: any BlockedBooksModel) async {
        await model
            .blockedBooksPublisher
            .removeDuplicates()
            .sink { @Sendable books in
                Task { @MainActor [weak self] in
                    self?.blockedBooks = books.map { BookViewModel(book: $0, favorite: false) }
                }
            }
            .store(in: &cancellables)
    }

}

#if DEBUG
import GoodreadsService

final class BlockedBooksPreviewViewModel: BlockedBooksViewModel {

    // MARK: - Properties

    // MARK: BlockedBooksViewModel protocol properties

    var blockedBooks = Book.previewFixtures.map { BookViewModel(book: $0, favorite: false) }
    var errorDisplayed = false

    // MARK: - Methods

    // MARK: BlockedBooksViewModel protocol methods

    func unblockBook(_ book: BookViewModel) {
        blockedBooks.removeAll { $0.id == book.id }
    }

    func makeDetailsViewModel(for book: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsPreviewViewModel()
    }

}
#endif
