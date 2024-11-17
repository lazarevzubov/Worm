//
//  SearchDefaultViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 7.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Dispatch

// MARK: -

/// The presentation logic of the book search screen relying on the default model implementation.
final class SearchDefaultViewModel: @unchecked Sendable, MainScreenViewModel, SearchViewModel {

    // MARK: - Properties

    // MARK: MainScreenViewModel protocol properties

    var query: String {
        get {
            booksSynchronizationQueue.sync { synchronizedQuery }
        }
        set {
            booksSynchronizationQueue.async(flags: .barrier) { self.synchronizedQuery = newValue }
        }
    }

    // MARK: SearchViewModel protocol properties

    @Published
    private(set) var books = [BookViewModel]()
    @Published
    var recommendationsOnboardingShown: Bool {
        didSet {
            onboardingSynchronizationQueue
                .async(flags: .barrier) { [weak self, recommendationsOnboardingShown] in
                    self?.onboardingService.searchOnboardingShown = recommendationsOnboardingShown
                }
        }
    }
    @Published
    var searchOnboardingShown: Bool

    // MARK: Private methods

    private let booksSynchronizationQueue = DispatchQueue(label: "com.lazarevzubov.SearchDefaultViewModel-books",
                                                          attributes: .concurrent)
    private let imageService: ImageService
    private let model: any SearchModel
    private let onboardingSynchronizationQueue = DispatchQueue(
        label: "com.lazarevzubov.SearchDefaultViewModel-onboarding", attributes: .concurrent
    )
    private lazy var cancellables = Set<AnyCancellable>()
    private var onboardingService: OnboardingService
    private var synchronizedQuery = "" {
        didSet {
            Task { await model.searchBooks(by: query) }
        }
    }

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

        bind(model: self.model)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Methods

    // MARK: SearchViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        model.toggleFavoriteStateOfBook(withID: id)
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

    private func bind(model: any SearchModel) {
        model
            .booksPublisher
            .removeDuplicates()
            .sink { books in
                Task { @MainActor [weak self] in
                    self?.books = books.map {
                        BookViewModel(book: $0, favorite: model.favoriteBookIDs.contains($0.id))
                    }
                }
            }
            .store(in: &cancellables)
        model
            .favoriteBookIDsPublisher
            .removeDuplicates()
            .sink { ids in
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
