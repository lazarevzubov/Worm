//
//  SearchViewModel.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 13.7.2024.
//

import Combine

/// The presentation logic of the book search screen.
protocol SearchViewModel: BookListCellViewModel, BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

    /// The list of books corresponding to the current search query.
    var books: [BookViewModel] { get }
    /// Whether an error alert about a failed save should be shown.
    var errorDisplayed: Bool { get set }
    /// Whether the onboarding about the recommendations has been already shown to the user.
    var recommendationsOnboardingShown: Bool { get set }
    /// Whether the onboarding about the searching has been already shown to the user.
    var searchOnboardingShown: Bool { get set }

}

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
    var errorDisplayed = false
    @Published
    var recommendationsOnboardingShown: Bool {
        didSet { onboardingService.recommendationsOnboardingShown = recommendationsOnboardingShown }
    }
    @Published
    var searchOnboardingShown: Bool {
        didSet { onboardingService.searchOnboardingShown = searchOnboardingShown }
    }

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
        recommendationsOnboardingShown = onboardingService.recommendationsOnboardingShown

        Task { [weak self] in
            await self?.bind(model: model)
        }
    }

    // MARK: - Methods

    // MARK: SearchViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        Task { @MainActor [weak self] in
            do {
                try await self?.model.toggleFavoriteStateOfBook(withID: id)
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

    private func bind(model: any SearchModel) async {
        await model
            .booksPublisher
            .removeDuplicates()
            .sink { @Sendable books in
                Task { @MainActor [weak self] in
                    let favoriteBookIDs = await model.favoriteBookIDs
                    self?.books = books.map { BookViewModel(book: $0, favorite: favoriteBookIDs.contains($0.id)) }
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
                    for bookIndex in books.indices {
                        books[bookIndex] = BookViewModel(
                            id: books[bookIndex].id,
                            authors: books[bookIndex].authors,
                            title: books[bookIndex].title,
                            description: books[bookIndex].description,
                            imageURL: books[bookIndex].imageURL,
                            rating: books[bookIndex].rating,
                            favorite: ids.contains(books[bookIndex].id)
                        )
                    }
                }
            }
            .store(in: &cancellables)
    }

}

#if DEBUG
// MARK: -

import GoodreadsService

final class SearchPreviewViewModel: SearchViewModel, BookListCellViewModel {

    // MARK: - Properties

    // MARK: SearchViewModel protocol properties

    var errorDisplayed = false
    var query = ""
    var recommendationsOnboardingShown = true
    var searchOnboardingShown = true
    private(set) var books = Book.previewFixtures.map { BookViewModel(book: $0, favorite: false) }

    // MARK: - Methods

    // MARK: SearchViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        books = books.map {
            BookViewModel(
                id: $0.id,
                authors: $0.authors,
                title: $0.title,
                description: $0.description,
                imageURL: nil,
                rating: $0.rating,
                favorite: ($0.id == id)
                    ? !$0.favorite
                    : $0.favorite
            )
        }
    }

    func makeDetailsViewModel(for favorite: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsPreviewViewModel()
    }

}
#endif
