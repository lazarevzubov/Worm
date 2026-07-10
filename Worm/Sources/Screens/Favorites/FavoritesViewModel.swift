//
//  FavoritesViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 11.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine

/// Object responsible for Favorites screen presentation logic.
protocol FavoritesViewModel: BookListCellViewModel, BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

    /// A list of view models representing items on the Favorites screen.
    var favorites: [BookViewModel] { get }

}

// MARK: -

/// The default implementation of the Favorites screen view model.
final class FavoritesDefaultViewModel: FavoritesViewModel {

    // MARK: - Properties

    // MARK: FavoritesViewModel protocol properties

    @Published
    private(set) var favorites = [BookViewModel]()

    // MARK: Private properties

    private let imageService: ImageService
    private let model: any FavoritesModel
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Creates a view model object.
    /// - Parameters:
    ///   - model: Data providing object.
    ///   - imageService: The services that turns image URLs into images themselves.
    init(model: any FavoritesModel, imageService: ImageService) {
        self.model = model
        self.imageService = imageService

        Task { [weak self] in
            await self?.bind(model: model)
        }
    }

    // MARK: - Methods

    // MARK: FavoritesViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        Task { await model.toggleFavoriteStateOfBook(withID: id) }
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

    private func bind(model: any FavoritesModel) async {
        await model
            .favoritesPublisher
            .removeDuplicates()
            .sink { @Sendable book in
                Task { @MainActor [weak self] in
                    self?.favorites = await model.favorites.map { BookViewModel(book: $0, favorite: true) }
                }
            }
            .store(in: &cancellables)
    }

}

#if DEBUG
import GoodreadsService

final class FavoritesPreviewsViewModel: FavoritesViewModel {

    // MARK: - Properties

    // MARK: FavoritesViewModel protocol properties

    private(set) var favorites = Book.previewFixtures.map { BookViewModel(book: $0, favorite: false) }

    // MARK: - Methods

    // MARK: FavoritesViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        favorites.removeAll { $0.id == id }
    }

    func makeDetailsViewModel(for favorite: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsPreviewViewModel()
    }

}
#endif
