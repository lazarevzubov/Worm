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

    private func bind(model: Model) {
        model
            .objectWillChange
            .receive(on: updateQueue)
            .sink { _ in
                self.objectWillChange.send()
                self.books = model
                    .books
                    .map { BookViewModel(authors: $0.authors.joined(separator: ", "), id: $0.id, title: $0.title) }
        }
        .store(in: &cancellables)
    }

}

// MARK: -

/// The mock presentation logic object for the book search screen preview.
final class MainPreviewPresenter: MainPresenter {

    // MARK: - Properties

    // MARK: MainPresenter protocol properties

    var books: [BookViewModel] {
        [BookViewModel(authors: "J.R.R. Tolkien", id: "1", title: "The Lord of the Rings"),
         BookViewModel(authors: "Michael Bond", id: "2", title: "Paddington Pop-Up London"),
         BookViewModel(authors: "J.K. Rowling", id: "3", title: "Harry Potter and the Sorcecer's Stone"),
         BookViewModel(authors: "George R.R. Martin", id: "4", title: "A Game of Thrones"),
         BookViewModel(authors: "Frank Herbert", id: "5", title: "Dune I"),
         BookViewModel(authors: "Mikhail Bulgakov", id: "6", title: "The Master and Margarita"),
         BookViewModel(authors: "Alan Moore", id: "7", title: "Watchmen"),
         BookViewModel(authors: "Steve McConnell", id: "8", title: "Code Complete"),
         BookViewModel(authors: "Jane Austen", id: "9", title: "Pride and Prejudice"),
         BookViewModel(authors: "Martin Fowler", id: "10", title: "Refactoring: Improving the Design of Existing Code"),
         BookViewModel(authors: "Stephen King", id: "11", title: "The Shining"),
         BookViewModel(authors: "Hannah Arendt",
                       id: "12",
                       title: "Eichmann in Jerusalem: A Report on the Banality of Evil"),
         BookViewModel(authors: "Fyodor Dostoyevsky", id: "13", title: "The Idiot"),
         BookViewModel(authors: "Ken Kesey", id: "14", title: "Sometimes a Great Notion"),
         BookViewModel(authors: "Haruki Murakami", id: "15", title: "The Wind-Up Bird Chronicle")]
    }
    var query = ""

}
