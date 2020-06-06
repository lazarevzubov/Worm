//
//  MainPresenter.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 7.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation
import GoodreadsService

/// A book data for a visual representation.
struct BookViewModel {

    // MARK: - Properties

    /// Formatted authors list.
    let authors: String
    /// Whether the book is in the favorites list.
    let favorite: Bool
    /// The book ID.
    let id: String
    /// The book title.
    let title: String

}

// MARK: - Equatable

extension BookViewModel: Equatable { }

// MARK: - Identifiable

extension BookViewModel: Identifiable { }

// MARK: -

/// The presentation logic of the book search screen.
protocol MainPresenter: ObservableObject {

    // MARK: - Properties

    /// The current search query.
    var query: String { get set }
    /// The list of books corresponding to the current search query.
    var books: [BookViewModel] { get }

    // MARK: - Methods

    /**
    Toggles the favorite-ness state of a book.
    - Parameter bookID: The ID of the book to manipulate.
    */
    func toggleFavoriteState(bookID: String)

}

// MARK: -

/// The presentation logic of the book search screen relying on the default model implementation.
final class MainDefaultPresenter<Model: MainModel>: MainPresenter {

    // MARK: - Properties

    // MARK: MainPresenter protocol properties

    var query: String = "" {
        didSet { model.searchBooks(by: query) }
    }
    @Published
    var books = [BookViewModel]()

    // MARK: Private methods

    private let model: Model
    private let updateQueue: DispatchQueue
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /**
     Creates the presentation logic object.
     - Parameter model: The search screen model.
     */
    init(model: Model, updateQueue: DispatchQueue = .main) {
        self.model = model
        self.updateQueue = updateQueue

        bind(model: self.model)
    }

    // MARK: - Methods

    // MARK: MainPresenter protocol methods

    func toggleFavoriteState(bookID: String) {
        model.toggleFavoriteState(bookID: bookID)
    }

    // MARK: Private methods

    private func bind(model: Model) {
        model
            .objectWillChange
            .receive(on: updateQueue)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
                self?.books = model.books.map { $0.asViewModel(favorite: model.favoriteBookIDs.contains($0.id)) }
        }
        .store(in: &cancellables)
    }

}

// MARK: -

/// The mock presentation logic object for the book search screen preview.
final class MainPreviewPresenter: MainPresenter {

    // MARK: - Properties

    // MARK: MainPresenter protocol properties

    private(set) var books: [BookViewModel] = [
        BookViewModel(authors: "J.R.R. Tolkien", favorite: true, id: "1", title: "The Lord of the Rings"),
        BookViewModel(authors: "Michael Bond", favorite: false, id: "2", title: "Paddington Pop-Up London"),
        BookViewModel(authors: "J.K. Rowling",
                      favorite: false,
                      id: "3",
                      title: "Harry Potter and the Sorcecer's Stone"),
        BookViewModel(authors: "George R.R. Martin", favorite: false, id: "4", title: "A Game of Thrones"),
        BookViewModel(authors: "Frank Herbert", favorite: true, id: "5", title: "Dune I"),
        BookViewModel(authors: "Mikhail Bulgakov", favorite: false, id: "6", title: "The Master and Margarita"),
        BookViewModel(authors: "Alan Moore", favorite: false, id: "7", title: "Watchmen"),
        BookViewModel(authors: "Steve McConnell", favorite: false, id: "8", title: "Code Complete"),
        BookViewModel(authors: "Jane Austen", favorite: true, id: "9", title: "Pride and Prejudice"),
        BookViewModel(authors: "Martin Fowler",
                      favorite: false,
                      id: "10",
                      title: "Refactoring: Improving the Design of Existing Code"),
        BookViewModel(authors: "Stephen King", favorite: false, id: "11", title: "The Shining"),
        BookViewModel(authors: "Hannah Arendt",
                      favorite: false,
                      id: "12",
                      title: "Eichmann in Jerusalem: A Report on the Banality of Evil"),
        BookViewModel(authors: "Fyodor Dostoyevsky", favorite: true, id: "13", title: "The Idiot"),
        BookViewModel(authors: "Ken Kesey", favorite: true, id: "14", title: "Sometimes a Great Notion"),
        BookViewModel(authors: "Haruki Murakami", favorite: false, id: "15", title: "The Wind-Up Bird Chronicle")
    ]
    var query = ""

    // MARK: - Methods

    // MARK: MainPresenter protocol methods

    func toggleFavoriteState(bookID: String) {
        books = books.map {
            BookViewModel(authors: $0.authors,
                          favorite: ($0.id == bookID ? !$0.favorite : $0.favorite),
                          id: $0.id,
                          title: $0.title)

        }
    }

}

// MARK: -

private extension Book {

    // MARK: - Methods

    func asViewModel(favorite: Bool) -> BookViewModel {
        BookViewModel(authors: authors.joined(separator: ", "), favorite: favorite, id: id, title: title)
    }

}
