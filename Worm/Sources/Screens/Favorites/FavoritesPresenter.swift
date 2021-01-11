//
//  FavoritesPresenter.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 11.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation

/// Object responsible for Favorites screen presentation logic.
protocol FavoritesPresenter: BookListCellPresenter, ObservableObject {

    // MARK: - Properties

    /// A list of view models represeting items on the Favorites screen.
    var favorites: [BookViewModel] { get }

}

// MARK: -

/// The default implementation of the Favorites screen presenter.
final class FavoritesDefaultPresenter<Model: FavoritesModel>: FavoritesPresenter {

    // MARK: - Properties

    // MARK: FavoritesPresenter protocol properties

    @Published
    private(set) var favorites = [BookViewModel]()

    // MARK: Private properties

    private let model: Model
    private let updateQueue: DispatchQueue
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /**
     Creates a presenter object.
     - Parameters:
        - model: Data providing object.
        - updateQueue: Queue on which presentation data is passed to view.
     */
    init(model: Model, updateQueue: DispatchQueue = .main) {
        self.model = model
        self.updateQueue = updateQueue
        
        bind(model: model)
    }

    // MARK: - Methods

    // MARK: FavoritesPresenter protocol methods

    func toggleFavoriteState(bookID: String) {
        model.toggleFavoriteState(bookID: bookID)
    }

    // MARK: Private methods

    private func bind(model: Model) {
        model
            .objectWillChange
            .receive(on: updateQueue)
            .sink { [weak self, weak model] _ in
                guard let self = self,
                      let model = model else {
                    return
                }

                self.objectWillChange.send()
                self.favorites = model.favorites.map { $0.asViewModel(favorite: true) }
        }
        .store(in: &cancellables)
    }

}

// MARK: -

/// The implementation of the Favorites screen presenter that used for SwiftUI previews.
final class FavoritesPreviewPresenter: FavoritesPresenter {

    // MARK: - Properties

    // MARK: FavoritesPresenter protocol properties

    var favorites = [
        BookViewModel(authors: "J.R.R. Tolkien", id: "1", isFavorite: false, title: "The Lord of the Rings"),
        BookViewModel(authors: "Michael Bond", id: "2", isFavorite: false, title: "Paddington Pop-Up London"),
        BookViewModel(authors: "J.K. Rowling",
                      id: "3",
                      isFavorite: false,
                      title: "Harry Potter and the Sorcecer's Stone"),
        BookViewModel(authors: "George R.R. Martin", id: "4", isFavorite: false, title: "A Game of Thrones"),
        BookViewModel(authors: "Frank Herbert", id: "5", isFavorite: false, title: "Dune I"),
        BookViewModel(authors: "Mikhail Bulgakov", id: "6", isFavorite: false, title: "The Master and Margarita"),
        BookViewModel(authors: "Alan Moore", id: "7", isFavorite: false, title: "Watchmen"),
        BookViewModel(authors: "Steve McConnell", id: "8", isFavorite: false, title: "Code Complete"),
        BookViewModel(authors: "Jane Austen", id: "9", isFavorite: false, title: "Pride and Prejudice"),
        BookViewModel(authors: "Martin Fowler",
                      id: "10",
                      isFavorite: false,
                      title: "Refactoring: Improving the Design of Existing Code"),
        BookViewModel(authors: "Stephen King", id: "11", isFavorite: false, title: "The Shining"),
        BookViewModel(authors: "Hannah Arendt",
                      id: "12",
                      isFavorite: false,
                      title: "Eichmann in Jerusalem: A Report on the Banality of Evil"),
        BookViewModel(authors: "Fyodor Dostoyevsky", id: "13", isFavorite: false, title: "The Idiot"),
        BookViewModel(authors: "Ken Kesey", id: "14", isFavorite: false, title: "Sometimes a Great Notion"),
        BookViewModel(authors: "Haruki Murakami", id: "15", isFavorite: false, title: "The Wind-Up Bird Chronicle")
    ]

    // MARK: - Methods

    // MARK: FavoritesPresenter protocol methods

    func toggleFavoriteState(bookID: String) {
        favorites.removeAll { $0.id == bookID }
    }

}
