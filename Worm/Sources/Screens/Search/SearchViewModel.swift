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
            booksSynchronizationQueue.sync { synchronizedQuery }
        }
        set {
            booksSynchronizationQueue.async(flags: .barrier) { self.synchronizedQuery = newValue }
        }
    }
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
    private let model: Model
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
    init(model: Model, onboardingService: OnboardingService, imageService: ImageService) {
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
        BookDetailsDefaultViewModel(authors: book.authors,
                                    title: book.title, 
                                    description: book.description,
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
                        self.books[bookIndex] = BookViewModel(id: self.books[bookIndex].id,
                                                              authors: self.books[bookIndex].authors,
                                                              title: self.books[bookIndex].title,
                                                              description: self.books[bookIndex].description,
                                                              imageURL: self.books[bookIndex].imageURL,
                                                              favorite: ids.contains(self.books[bookIndex].id))
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

    var query: String {
        get {
            booksSynchronizationQueue.sync { synchronizedQuery }
        }
        set {
            booksSynchronizationQueue.async(flags: .barrier) { self.synchronizedQuery = newValue }
        }
    }
    var recommendationsOnboardingShown: Bool {
        get {
            recommendationsOnboardingSynchronizationQueue.sync { synchronizedRecommendationsOnboardingShown }
        }
        set {
            recommendationsOnboardingSynchronizationQueue.async(flags: .barrier) {
                self.synchronizedRecommendationsOnboardingShown = newValue
            }
        }
    }
    var searchOnboardingShown: Bool {
        get {
            searchOnboardingSynchronizationQueue.sync { synchronizedSearchOnboardingShown }
        }
        set {
            searchOnboardingSynchronizationQueue.async(flags: .barrier) {
                self.synchronizedSearchOnboardingShown = newValue
            }
        }
    }
    private(set) var books = [
        BookViewModel(id: "1",
                      authors: "J.R.R. Tolkien",
                      title: "The Lord of the Rings",
                      description: "A sensitive hobbit unexpectedly saves the situation.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "2",
                      authors: "Michael Bond",
                      title: "Paddington Pop-Up London",
                      description: "A cute pop-up book about London, the capital of The United Kingdom.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "3",
                      authors: "J.K. Rowling",
                      title: "Harry Potter and the Sorcecer's Stone",
                      description: "Another sensitive teenager saves the day thank to his friends.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "4",
                      authors: "George R.R. Martin",
                      title: "A Game of Thrones",
                      description: "Caligula with magic and dragons.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "5",
                      authors: "Frank Herbert",
                      title: "Dune I",
                      description: "A good example of why immigrants can be useful to a country (or a planet).",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(
            id: "6",
            authors: "Mikhail Bulgakov",
            title: "The Master and Margarita",
            description: "An exception that proves that some books from the public school program are actually good.",
            imageURL: nil,
            favorite: false
        ),
        BookViewModel(id: "7",
                      authors: "Alan Moore",
                      title: "Watchmen",
                      description: "Aging superheroes with psychological issues face the demons of their past.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "8",
                      authors: "Steve McConnell",
                      title: "Code Complete",
                      description: "How to make your code a bit less shitty.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "9",
                      authors: "Jane Austen",
                      title: "Pride and Prejudice",
                      description: "More than just a love story.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "10",
                      authors: "Martin Fowler",
                      title: "Refactoring: Improving the Design of Existing Code",
                      description: "A step-by-step guide how to make your code bearable to work with.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "11",
                      authors: "Stephen King",
                      title: "The Shining",
                      description: "How the family can drive a person crazy, when they are locked up together.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "12",
                      authors: "Hannah Arendt",
                      title: "Eichmann in Jerusalem: A Report on the Banality of Evil",
                      description: "How the Jew made their situation even worse during WWII.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "13",
                      authors: "Fyodor Dostoyevsky",
                      title: "The Idiot",
                      description: "A book about a nice person in the world of idiots (i.e., the real world).",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "14",
                      authors: "Ken Kesey",
                      title: "Sometimes a Great Notion",
                      description: "A story that proves you must stay away of your family after you grow up.",
                      imageURL: nil,
                      favorite: false),
        BookViewModel(id: "15",
                      authors: "Haruki Murakami",
                      title: "The Wind-Up Bird Chronicle",
                      description: "A half anime-pervert, half meditating phantasy.",
                      imageURL: nil,
                      favorite: false)
    ]

    // MARK: Private properties

    private let booksSynchronizationQueue = DispatchQueue(label: "com.lazarevzubov.SearchPreviewViewModel-books",
                                                          attributes: .concurrent)
    private let recommendationsOnboardingSynchronizationQueue = DispatchQueue(
        label: "com.lazarevzubov.SearchPreviewViewModel-recommendationsOnboarding", attributes: .concurrent
    )
    private let searchOnboardingSynchronizationQueue = DispatchQueue(
        label: "com.lazarevzubov.SearchPreviewViewModel-searchOnboarding", attributes: .concurrent
    )
    private var synchronizedQuery = ""
    private var synchronizedRecommendationsOnboardingShown = false
    private var synchronizedSearchOnboardingShown = false

    // MARK: - Methods

    // MARK: SearchViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        booksSynchronizationQueue.async(flags: .barrier) {
            self.books = self.books.map {
                BookViewModel(id: $0.id,
                              authors: $0.authors,
                              title: $0.title, 
                              description: $0.description,
                              imageURL: nil,
                              favorite: ($0.id == id)
                                            ? !$0.favorite
                                            : $0.favorite)

            }
        }
    }

    func makeDetailsViewModel(for favorite: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsPreviewViewModel()
    }

}

#endif
