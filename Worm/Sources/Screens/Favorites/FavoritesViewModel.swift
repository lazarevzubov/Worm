//
//  FavoritesViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 11.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Dispatch

/// Object responsible for Favorites screen presentation logic.
protocol FavoritesViewModel: BookListCellViewModel, BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

    /// A list of view models representing items on the Favorites screen.
    var favorites: [BookViewModel] { get }

}

// MARK: -

/// The default implementation of the Favorites screen view model.
final class FavoritesDefaultViewModel<Model: FavoritesModel>: @unchecked Sendable, FavoritesViewModel {

    // MARK: - Properties

    // MARK: FavoritesViewModel protocol properties

    @Published
    private(set) var favorites = [BookViewModel]()

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

    // MARK: FavoritesViewModel protocol methods

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
            .favoritesPublisher
            .removeDuplicates()
            .sink { book in
                Task { @MainActor [weak self, weak model] in
                    guard let model else {
                        return
                    }
                    self?.favorites = model.favorites.map { BookViewModel(book: $0, favorite: true) }
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: -

#if DEBUG

final class FavoritesPreviewsViewModel: @unchecked Sendable, FavoritesViewModel {

    // MARK: - Properties

    // MARK: FavoritesViewModel protocol properties

    private(set) var favorites = [
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

    // MARK: FavoritesViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        favorites.removeAll { $0.id == id }
    }

    func makeDetailsViewModel(for favorite: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsPreviewViewModel()
    }

}

#endif
