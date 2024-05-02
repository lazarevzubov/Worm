//
//  RecommendationsViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine

/// Object responsible for Recommendations screen presentation logic.
protocol RecommendationsViewModel: BookListCellViewModel, BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

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
    private(set) var recommendations = [BookViewModel]()

    // MARK: Private properties

    private let imageService: ImageService
    private let model: Model
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Creates a view model object.
    /// - Parameters:
    ///   - model: Data providing object.
    ///   - imageService: The services that turns image URLs into images themselves.
    init(model: Model, imageService: ImageService) {
        self.model = model
        self.imageService = imageService

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
            .sink { recommendations in
                Task { @MainActor in
                    self.recommendations = recommendations
                        .map { BookViewModel(book: $0, favorite: model.favoriteBookIDs.contains($0.id)) }
                        .filter { !$0.favorite }
                }
            }
            .store(in: &cancellables)
    }

}

#if DEBUG

// MARK: -

final class RecommendationsPreviewViewModel: RecommendationsViewModel {

    // MARK: - Properties

    // MARK: RecommendationsViewModel protocol properties

    let recommendations = [
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