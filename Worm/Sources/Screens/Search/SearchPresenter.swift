//
//  SearchPresenter.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 7.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation

// FIXME: Same model objects for all layers.

/// The presentation logic of the book search screen.
protocol SearchPresenter: BookListCellPresenter, BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

    /// The current search query.
    var query: String { get set }
    /// The list of books corresponding to the current search query.
    var books: [BookViewModel] { get }

}

// MARK: -

/// The presentation logic of the book search screen relying on the default model implementation.
final class SearchDefaultPresenter<Model: SearchModel>: SearchPresenter {

    typealias DetailsPresenter = BookDetailsDefaultPresenter

    // MARK: - Properties

    // MARK: SearchPresenter protocol properties

    var query: String = "" {
        didSet { model.searchBooks(by: query) }
    }
    @Published
    private(set) var books = [BookViewModel]()

    // MARK: Private methods

    private let imageService: ImageService
    private let model: Model
    private let updateQueue: DispatchQueue
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /**
     Creates the presentation logic object.
     - Parameters:
        - model: The search screen model.
        - imageService: The services that turns image URLs into images themselves.
        - updateQueue: Queue on which presentation data is passed to view.
     */
    init(model: Model, imageService: ImageService, updateQueue: DispatchQueue = .main) {
        self.model = model
        self.imageService = imageService
        self.updateQueue = updateQueue

        bind(model: self.model)
    }

    // MARK: - Methods

    // MARK: SearchPresenter protocol methods

    func toggleFavoriteState(bookID: String) {
        model.toggleFavoriteState(bookID: bookID)
    }

    func makeDetailsPresenter(for book: BookViewModel) -> DetailsPresenter {
        BookDetailsDefaultPresenter(authors: book.authors,
                                    title: book.title,
                                    imageURL: book.imageURL,
                                    imageService: imageService)
    }

    // MARK: Private methods

    private func bind(model: Model) {
        model
            .objectWillChange
            .receive(on: updateQueue)
            .sink { [weak self, weak model] _ in
                guard let self,
                      let model else {
                    return
                }

                self.objectWillChange.send()
                self.books = model.books.map { $0.asViewModel(favorite: model.favoriteBookIDs.contains($0.id)) }
            }
            .store(in: &cancellables)
    }

}

// MARK: -

/// The mock presentation logic object for the book search screen preview.
final class SearchPreviewPresenter: SearchPresenter, BookListCellPresenter {

    typealias DetailsPresenter = BookDetailsPreviewPresenter

    // MARK: - Properties

    // MARK: SearchPresenter protocol properties

    private(set) var books = [
        BookViewModel(authors: "J.R.R. Tolkien",
                      id: "1",
                      imageURL: nil,
                      isFavorite: false,
                      title: "The Lord of the Rings"),
        BookViewModel(authors: "Michael Bond",
                      id: "2",
                      imageURL: nil,
                      isFavorite: false,
                      title: "Paddington Pop-Up London"),
        BookViewModel(authors: "J.K. Rowling",
                      id: "3",
                      imageURL: nil,
                      isFavorite: false,
                      title: "Harry Potter and the Sorcecer's Stone"),
        BookViewModel(authors: "George R.R. Martin",
                      id: "4",
                      imageURL: nil,
                      isFavorite: false,
                      title: "A Game of Thrones"),
        BookViewModel(authors: "Frank Herbert", id: "5", imageURL: nil, isFavorite: false, title: "Dune I"),
        BookViewModel(authors: "Mikhail Bulgakov",
                      id: "6",
                      imageURL: nil,
                      isFavorite: false,
                      title: "The Master and Margarita"),
        BookViewModel(authors: "Alan Moore", id: "7", imageURL: nil, isFavorite: false, title: "Watchmen"),
        BookViewModel(authors: "Steve McConnell", id: "8", imageURL: nil, isFavorite: false, title: "Code Complete"),
        BookViewModel(authors: "Jane Austen", id: "9", imageURL: nil, isFavorite: false, title: "Pride and Prejudice"),
        BookViewModel(authors: "Martin Fowler",
                      id: "10",
                      imageURL: nil,
                      isFavorite: false,
                      title: "Refactoring: Improving the Design of Existing Code"),
        BookViewModel(authors: "Stephen King", id: "11", imageURL: nil, isFavorite: false, title: "The Shining"),
        BookViewModel(authors: "Hannah Arendt",
                      id: "12",
                      imageURL: nil,
                      isFavorite: false,
                      title: "Eichmann in Jerusalem: A Report on the Banality of Evil"),
        BookViewModel(authors: "Fyodor Dostoyevsky", id: "13", imageURL: nil, isFavorite: false, title: "The Idiot"),
        BookViewModel(authors: "Ken Kesey",
                      id: "14",
                      imageURL: nil,
                      isFavorite: false,
                      title: "Sometimes a Great Notion"),
        BookViewModel(authors: "Haruki Murakami",
                      id: "15",
                      imageURL: nil,
                      isFavorite: false,
                      title: "The Wind-Up Bird Chronicle")
    ]
    var query = ""

    // MARK: - Methods

    // MARK: SearchPresenter protocol methods

    func toggleFavoriteState(bookID: String) {
        books = books.map {
            BookViewModel(authors: $0.authors,
                          id: $0.id,
                          imageURL: nil,
                          isFavorite: ($0.id == bookID)
                                          ? !$0.isFavorite
                                          : $0.isFavorite,
                          title: $0.title)

        }
    }

    func makeDetailsPresenter(for favorite: BookViewModel) -> DetailsPresenter {
        BookDetailsPreviewPresenter()
    }

}
