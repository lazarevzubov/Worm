//
//  SearchDefaultViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 7.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine

// MARK: -

/// The presentation logic of the book search screen relying on the default model implementation.
final class SearchDefaultViewModel: MainScreenViewModel, SearchViewModel {

    // MARK: - Properties

    // MARK: MainScreenViewModel protocol properties

    var query = "" {
        didSet {
            Task { await model.searchBooks(by: query) }
        }
    }

    // MARK: SearchViewModel protocol properties

    @Published
    private(set) var books = [BookViewModel]()
    @Published
    var recommendationsOnboardingShown: Bool {
        didSet { onboardingService.searchOnboardingShown = recommendationsOnboardingShown }
    }
    @Published
    var searchOnboardingShown: Bool

    // MARK: Private methods

    private let imageService: ImageService
    private let model: any SearchModel
    private lazy var cancellables = Set<AnyCancellable>()
    private var onboardingService: OnboardingService

    // MARK: - Initialization

    /// Creates the presentation logic object.
    /// - Parameters:
    ///   - model: The search screen model.
    ///   - onboardingService: Provides with information related to the user onboarding.
    ///   - imageService: The services that turns image URLs into images themselves.
    init(model: any SearchModel, onboardingService: OnboardingService, imageService: ImageService) {
        self.model = model
        self.onboardingService = onboardingService
        self.imageService = imageService

        searchOnboardingShown = onboardingService.searchOnboardingShown
        recommendationsOnboardingShown = onboardingService.searchOnboardingShown

        Task { [weak self] in
            await self?.bind(model: model)
        }
    }

    // MARK: - Methods

    // MARK: SearchViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        Task { [weak self] in
            await self?.model.toggleFavoriteStateOfBook(withID: id)
        }
    }

    func makeDetailsViewModel(for book: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsDefaultViewModel(
            authors: book.authors,
            title: book.title,
            description: book.description,
            imageURL: book.imageURL,
            imageService: imageService
        )
    }

    // MARK: Private methods

    private func bind(model: any SearchModel) async {
        await model
            .booksPublisher
            .removeDuplicates()
            .sink { @Sendable books in
                Task { [weak self] in
                    guard let self else {
                        return
                    }

                    let favoriteBookIDs = await model.favoriteBookIDs
                    Task { @MainActor [weak self] in
                        self?.books = books.map { BookViewModel(book: $0, favorite: favoriteBookIDs.contains($0.id)) }
                    }
                }
            }
            .store(in: &cancellables)
        await model
            .favoriteBookIDsPublisher
            .removeDuplicates()
            .sink { @Sendable ids in
                Task { @MainActor [weak self] in
                    guard let self else {
                        return
                    }
                    for bookIndex in self.books.indices {
                        self.books[bookIndex] = BookViewModel(
                            id: self.books[bookIndex].id,
                            authors: self.books[bookIndex].authors,
                            title: self.books[bookIndex].title,
                            description: self.books[bookIndex].description,
                            imageURL: self.books[bookIndex].imageURL,
                            favorite: ids.contains(self.books[bookIndex].id)
                        )
                    }
                }
            }
            .store(in: &cancellables)
    }

}
