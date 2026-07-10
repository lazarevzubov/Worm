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
                Task { @MainActor [weak self] in
                    let favoriteBookIDs = await model.favoriteBookIDs
                    self?.unfilteredRecommendations = recommendations
                        .map { BookViewModel(book: $0, favorite: favoriteBookIDs.contains($0.id)) }
                        .filter { !$0.favorite }
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
import GoodreadsService

final class RecommendationsPreviewViewModel: RecommendationsViewModel, ObservableObject {

    // MARK: - Properties

    // MARK: RecommendationsViewModel protocol properties

    @Published
    var appliedFilters = [RecommendationsFilter]()
    var onboardingShown = true
    let recommendations = Book.previewFixtures.map { BookViewModel(book: $0, favorite: false) }

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
