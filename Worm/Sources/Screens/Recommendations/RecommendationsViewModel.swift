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
protocol RecommendationsViewModel: BookListCellViewModel, FiltersViewModel, BookDetailsPresentable {

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
final class RecommendationsDefaultViewModel: RecommendationsViewModel {

    // MARK: - Properties

    // MARK: RecommendationsViewModel protocol properties

    @Published
    var appliedFilters = [RecommendationsFilter]() {
        didSet { updateRecommendations(with: unfilteredRecommendations) }
    }
    @Published
    var onboardingShown: Bool {
        didSet { onboardingService.recommendationsOnboardingShown = onboardingShown }
    }
    @Published
    private(set) var recommendations = [BookViewModel]()

    // MARK: Private properties

    private let imageService: ImageService
    private let model: any RecommendationsModel
    private lazy var cancellables = Set<AnyCancellable>()
    private var onboardingService: OnboardingService
    private var unfilteredRecommendations = [BookViewModel]() {
        didSet { updateRecommendations(with: unfilteredRecommendations) }
    }

    // MARK: - Initialization

    /// Creates a view model object.
    /// - Parameters:
    ///   - model: Data providing object.
    ///   - onboardingService: Provides with information related to the user onboarding.
    ///   - imageService: The services that turns image URLs into images themselves.
    init(model: any RecommendationsModel, onboardingService: OnboardingService, imageService: ImageService) {
        self.model = model
        self.onboardingService = onboardingService
        self.imageService = imageService

        onboardingShown = onboardingService.recommendationsOnboardingShown

        Task { [weak self] in
            await self?.bind(model: model)
        }
    }

    // MARK: - Methods

    // MARK: RecommendationsViewModel protocol methods

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

    func blockRecommendation(_ recommendation: BookViewModel) {
        Task { await model.blockFromRecommendationsBook(withID: recommendation.id) }
    }

    // MARK: Private methods

    private func bind(model: any RecommendationsModel) async {
        await model
            .recommendationsPublisher
            .removeDuplicates()
            .debounce(for: .seconds(2), scheduler: RunLoop.main)
            .sink { @Sendable [weak self] recommendations in
                Task { [weak self] in
                    guard let self else {
                        return
                    }

                    let favoriteBookIDs = await model.favoriteBookIDs
                    Task { @MainActor [weak self] in
                        self?.unfilteredRecommendations = recommendations
                            .map { BookViewModel(book: $0, favorite: favoriteBookIDs.contains($0.id)) }
                            .filter { !$0.favorite }
                    }
                }
            }
            .store(in: &cancellables)
        await model
            .favoriteBookIDsPublisher
            .sink { @Sendable ids in
                Task { @MainActor [weak self] in
                    self?.unfilteredRecommendations.removeAll { ids.contains($0.id) }
                }
            }
            .store(in: &cancellables)
    }

    private func updateRecommendations(with unfilteredRecommendations: [BookViewModel]) {
        var recommendations = unfilteredRecommendations
        appliedFilters.forEach {
            switch $0 {
                case .topRated:
                    recommendations = recommendations.filter { ($0.rating ?? .zero) >= 4.0 }
            }
        }

        self.recommendations = recommendations
    }

}

#if DEBUG

// MARK: -

final class RecommendationsPreviewViewModel: RecommendationsViewModel, ObservableObject {

    // MARK: - Properties

    // MARK: RecommendationsViewModel protocol properties

    @Published
    var appliedFilters = [RecommendationsFilter]()
    var onboardingShown = true
    let recommendations = [
        BookViewModel(
            id: "1",
            authors: "J.R.R. Tolkien",
            title: "The Lord of the Rings",
            description: "A sensitive hobbit unexpectedly saves the situation.",
            imageURL: nil,
            rating: nil,
            favorite: false
        ),
        BookViewModel(
            id: "2",
            authors: "Michael Bond",
            title: "Paddington Pop-Up London",
            description: "A cute pop-up book about London, the capital of The United Kingdom.",
            imageURL: nil,
            rating: 0.12,
            favorite: false
        ),
        BookViewModel(
            id: "3",
            authors: "J.K. Rowling",
            title: "Harry Potter and the Sorcecer's Stone",
            description: "Another sensitive teenager saves the day thank to his friends.",
            imageURL: nil,
            rating: 1.23,
            favorite: false
        ),
        BookViewModel(
            id: "4",
            authors: "George R.R. Martin",
            title: "A Game of Thrones",
            description: "Caligula with magic and dragons.",
            imageURL: nil,
            rating: 2.34,
            favorite: false
        ),
        BookViewModel(
            id: "5",
            authors: "Frank Herbert",
            title: "Dune I",
            description: "A good example of why immigrants can be useful to a country (or a planet).",
            imageURL: nil,
            rating: 3.45,
            favorite: false
        ),
        BookViewModel(
            id: "6",
            authors: "Mikhail Bulgakov",
            title: "The Master and Margarita",
            description: "An exception that proves that some books from the public school program are actually good.",
            imageURL: nil,
            rating: 4.56,
            favorite: false
        ),
        BookViewModel(
            id: "7",
            authors: "Alan Moore",
            title: "Watchmen",
            description: "Aging superheroes with psychological issues face the demons of their past.",
            imageURL: nil,
            rating: nil,
            favorite: false
        ),
        BookViewModel(
            id: "8",
            authors: "Steve McConnell",
            title: "Code Complete",
            description: "How to make your code a bit less shitty.",
            imageURL: nil,
            rating: 1.23,
            favorite: false
        ),
        BookViewModel(
            id: "9",
            authors: "Jane Austen",
            title: "Pride and Prejudice",
            description: "More than just a love story.",
            imageURL: nil,
            rating: 2.34,
            favorite: false
        ),
        BookViewModel(
            id: "10",
            authors: "Martin Fowler",
            title: "Refactoring: Improving the Design of Existing Code",
            description: "A step-by-step guide how to make your code bearable to work with.",
            imageURL: nil,
            rating: 3.45,
            favorite: false
        ),
        BookViewModel(
            id: "11",
            authors: "Stephen King",
            title: "The Shining",
            description: "How the family can drive a person crazy, when they are locked up together.",
            imageURL: nil,
            rating: 4.56,
            favorite: false
        ),
        BookViewModel(
            id: "12",
            authors: "Hannah Arendt",
            title: "Eichmann in Jerusalem: A Report on the Banality of Evil",
            description: "How the Jew made their situation even worse during WWII.",
            imageURL: nil,
            rating: nil,
            favorite: false
        ),
        BookViewModel(
            id: "13",
            authors: "Fyodor Dostoyevsky",
            title: "The Idiot",
            description: "A book about a nice person in the world of idiots (i.e., the real world).",
            imageURL: nil,
            rating: 2.34,
            favorite: false
        ),
        BookViewModel(
            id: "14",
            authors: "Ken Kesey",
            title: "Sometimes a Great Notion",
            description: "A story that proves you must stay away of your family after you grow up.",
            imageURL: nil,
            rating: 3.45,
            favorite: false
        ),
        BookViewModel(
            id: "15",
            authors: "Haruki Murakami",
            title: "The Wind-Up Bird Chronicle",
            description: "A half anime-pervert, half meditating phantasy.",
            imageURL: nil,
            rating: 4.56,
            favorite: false
        )
    ]

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
