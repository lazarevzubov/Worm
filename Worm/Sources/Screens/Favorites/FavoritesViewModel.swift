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
final class FavoritesDefaultViewModel: @unchecked Sendable, FavoritesViewModel {

    // MARK: - Properties

    // MARK: FavoritesViewModel protocol properties

    @Published
    private(set) var favorites = [BookViewModel]()

    // MARK: Private properties

    private let imageService: ImageService
    private let model: any FavoritesModel
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /// Creates a view model object.
    /// - Parameters:
    ///   - model: Data providing object.
    ///   - imageService: The services that turns image URLs into images themselves.
    init(model: any FavoritesModel, imageService: ImageService) {
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
                                    description: book.description,
                                    imageURL: book.imageURL,
                                    imageService: imageService)
    }

    // MARK: Private methods

    private func bind(model: any FavoritesModel) {
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
