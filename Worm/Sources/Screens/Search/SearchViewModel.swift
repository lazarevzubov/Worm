//
//  SearchViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 7.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Dispatch

/// The presentation logic of the book search screen.
protocol SearchViewModel: BookListCellViewModel, BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

    /// The list of books corresponding to the current search query.
    var books: [BookViewModel] { get }
    /// The current search query.
    var query: String { get set }
    /// Whether the onboarding about the recommendations has been already shown to the user.
    var recommendationsOnboardingShown: Bool { get set }
    /// Whether the onboarding about the searching has been already shown to the user.
    var searchOnboardingShown: Bool { get set }

}

// MARK: -

/// The presentation logic of the book search screen relying on the default model implementation.
final class SearchDefaultViewModel<Model: SearchModel>: @unchecked Sendable, SearchViewModel {

    // MARK: - Properties

    // MARK: SearchViewModel protocol properties

    @Published
    private(set) var books = [BookViewModel]()
    var query: String {
        get {
            synchronizationQueue.sync { synchronizedQuery }
        }
        set {
            synchronizationQueue.async(flags: .barrier) { self.synchronizedQuery = newValue }
        }
    }
    @Published
    var recommendationsOnboardingShown: Bool {
        didSet { onboardingService.onboardingShown = recommendationsOnboardingShown }
    }
    @Published
    var searchOnboardingShown: Bool

    // MARK: Private methods

    private let imageService: ImageService
    private let model: Model
    private let synchronizationQueue = DispatchQueue(label: "com.lazarevzubov.SearchDefaultViewModel",
                                                     attributes: .concurrent)
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
    init(model: Model, onboardingService: OnboardingService, imageService: ImageService) {
        self.model = model
        self.onboardingService = onboardingService
        self.imageService = imageService

        searchOnboardingShown = onboardingService.onboardingShown
        recommendationsOnboardingShown = onboardingService.onboardingShown

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
        BookDetailsDefaultViewModel(authors: book.authors,
                                    title: book.title,
                                    imageURL: book.imageURL,
                                    imageService: imageService)
    }

    // MARK: Private methods

    private func bind(model: Model) {
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
                        self.books[bookIndex] = BookViewModel(authors: self.books[bookIndex].authors,
                                                              id: self.books[bookIndex].id,
                                                              imageURL: self.books[bookIndex].imageURL,
                                                              favorite: ids.contains(self.books[bookIndex].id),
                                                              title: self.books[bookIndex].title)
                    }
                }
            }
            .store(in: &cancellables)
    }

}

#if DEBUG

// MARK: -

final class SearchPreviewViewModel: @unchecked Sendable, SearchViewModel, BookListCellViewModel {

    // MARK: - Properties

    // MARK: SearchViewModel protocol properties

    var query = ""
    var recommendationsOnboardingShown = false
    var searchOnboardingShown = false
    private(set) var books = [
        BookViewModel(authors: "J.R.R. Tolkien",
                      id: "1",
                      imageURL: nil,
                      favorite: false,
                      title: "The Lord of the Rings"),
        BookViewModel(authors: "Michael Bond",
                      id: "2",
                      imageURL: nil,
                      favorite: false,
                      title: "Paddington Pop-Up London"),
        BookViewModel(authors: "J.K. Rowling",
                      id: "3",
                      imageURL: nil,
                      favorite: false,
                      title: "Harry Potter and the Sorcecer's Stone"),
        BookViewModel(authors: "George R.R. Martin",
                      id: "4",
                      imageURL: nil,
                      favorite: false,
                      title: "A Game of Thrones"),
        BookViewModel(authors: "Frank Herbert", id: "5", imageURL: nil, favorite: false, title: "Dune I"),
        BookViewModel(authors: "Mikhail Bulgakov",
                      id: "6",
                      imageURL: nil,
                      favorite: false,
                      title: "The Master and Margarita"),
        BookViewModel(authors: "Alan Moore", id: "7", imageURL: nil, favorite: false, title: "Watchmen"),
        BookViewModel(authors: "Steve McConnell", id: "8", imageURL: nil, favorite: false, title: "Code Complete"),
        BookViewModel(authors: "Jane Austen", id: "9", imageURL: nil, favorite: false, title: "Pride and Prejudice"),
        BookViewModel(authors: "Martin Fowler",
                      id: "10",
                      imageURL: nil,
                      favorite: false,
                      title: "Refactoring: Improving the Design of Existing Code"),
        BookViewModel(authors: "Stephen King", id: "11", imageURL: nil, favorite: false, title: "The Shining"),
        BookViewModel(authors: "Hannah Arendt",
                      id: "12",
                      imageURL: nil,
                      favorite: false,
                      title: "Eichmann in Jerusalem: A Report on the Banality of Evil"),
        BookViewModel(authors: "Fyodor Dostoyevsky", id: "13", imageURL: nil, favorite: false, title: "The Idiot"),
        BookViewModel(authors: "Ken Kesey",
                      id: "14",
                      imageURL: nil,
                      favorite: false,
                      title: "Sometimes a Great Notion"),
        BookViewModel(authors: "Haruki Murakami",
                      id: "15",
                      imageURL: nil,
                      favorite: false,
                      title: "The Wind-Up Bird Chronicle")
    ]

    // MARK: Private properties

    private let synchronizationQueue = DispatchQueue(label: "com.lazarevzubov.SearchPreviewViewModel",
                                                     attributes: .concurrent)

    // MARK: - Methods

    // MARK: SearchViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        synchronizationQueue.async(flags: .barrier) {
            self.books = self.books.map {
                BookViewModel(authors: $0.authors,
                              id: $0.id,
                              imageURL: nil,
                              favorite: ($0.id == id)
                              ? !$0.favorite
                              : $0.favorite,
                              title: $0.title)

            }
        }
    }

    func makeDetailsViewModel(for favorite: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsPreviewViewModel()
    }

}

#endif
