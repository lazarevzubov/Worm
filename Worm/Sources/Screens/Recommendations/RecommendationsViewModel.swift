//
//  RecommendationsViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation

/// Object responsible for Recommendations screen presentation logic.
protocol RecommendationsViewModel: BookListCellViewModel, BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

    /// Whether the onboarding has been already shown to the user.
    var onboardingShown: Bool { get set }
    /// A list of view models representing items on the Recommendations screen.
    var recommendations: [BookViewModel] { get }

    // MARK: - Methods

    /// Blocks a book from appearing as a recommendation.
    /// - Parameter recommendation: The book to block.
    func blockRecommendation(_ recommendation: BookViewModel)

}

// MARK: -

/// The default implementation of the Recommendations screen view model.
final class RecommendationsDefaultViewModel<Model: RecommendationsModel>: @unchecked Sendable,
                                                                          RecommendationsViewModel {

    // MARK: - Properties

    // MARK: RecommendationsViewModel protocol properties

    @Published
    var onboardingShown: Bool {
        didSet {
            onboardingSynchronizationQueue.async(flags: .barrier) { [weak self, onboardingShown] in
                self?.onboardingService.recommendationsOnboardingShown = onboardingShown
            }
        }
    }
    @Published
    private(set) var recommendations = [BookViewModel]()

    // MARK: Private properties

    private let imageService: ImageService
    private let model: Model
    private let onboardingSynchronizationQueue = DispatchQueue(
        label: "com.lazarevzubov.RecommendationsDefaultViewModel-onboarding", attributes: .concurrent
    )
    private lazy var cancellables = Set<AnyCancellable>()
    private var onboardingService: OnboardingService

    // MARK: - Initialization

    /// Creates a view model object.
    /// - Parameters:
    ///   - model: Data providing object.
    ///   - onboardingService: Provides with information related to the user onboarding.
    ///   - imageService: The services that turns image URLs into images themselves.
    init(model: Model, onboardingService: OnboardingService, imageService: ImageService) {
        self.model = model
        self.onboardingService = onboardingService
        self.imageService = imageService

        onboardingShown = onboardingService.recommendationsOnboardingShown

        bind(model: model)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // MARK: - Methods

    // MARK: RecommendationsViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) async {
        await model.toggleFavoriteStateOfBook(withID: id)
    }

    func makeDetailsViewModel(for book: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsDefaultViewModel(authors: book.authors,
                                    title: book.title,
                                    description: book.description,
                                    imageURL: book.imageURL,
                                    imageService: imageService)
    }

    func blockRecommendation(_ recommendation: BookViewModel) {
        model.blockFromRecommendationsBook(withID: recommendation.id)
    }

    // MARK: Private methods

    private func bind(model: Model) {
        model
            .recommendationsPublisher
            .removeDuplicates()
            .debounce(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] recommendations in
                self?.recommendations = recommendations
                    .map { BookViewModel(book: $0, favorite: model.favoriteBookIDs.contains($0.id)) }
                    .filter { !$0.favorite }
            }
            .store(in: &cancellables)
        model
            .favoriteBookIDsPublisher
            .sink { ids in
                Task { @MainActor [weak self] in
                    self?.recommendations.removeAll { ids.contains($0.id) }
                }
            }
            .store(in: &cancellables)
    }

}

#if DEBUG

// MARK: -

final class RecommendationsPreviewViewModel: @unchecked Sendable, RecommendationsViewModel {

    // MARK: - Properties

    // MARK: RecommendationsViewModel protocol properties

    var onboardingShown: Bool {
        get {
            onboardingSynchronizationQueue.sync { synchronizedOnboardingShown }
        }
        set {
            onboardingSynchronizationQueue.async(flags: .barrier) { self.synchronizedOnboardingShown = newValue }
        }
    }
    let recommendations = [
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

    // MARK: Private methods

    private let onboardingSynchronizationQueue = DispatchQueue(
        label: "com.lazarevzubov.RecommendationsPreviewViewModel-onboarding", attributes: .concurrent
    )
    private var synchronizedOnboardingShown = false

    // MARK: - Methods

    // MARK: BookListCellViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        // Do nothing in previews.
    }

    func makeDetailsViewModel(for favorite: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsPreviewViewModel()
    }

    func blockRecommendation(_ recommendation: BookViewModel) {
        // Do nothing in previews.
    }

}

#endif
