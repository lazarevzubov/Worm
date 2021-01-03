//
//  RecommendationsPresenter.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation

// TODO: Blocking books from recommendations.

/// Object responsible for Recommendations screen presentation logic.
protocol RecommendationsPresenter: ObservableObject {

    // MARK: - Properties

    /// A list of view models represeting items on the Recommendations screen.
    var recommendations: [BookViewModel] { get }

}

// MARK: -

/// The default implementation of the Recommendations screen presenter.
final class RecommendationsDefaultPresenter<Model: RecommendationsModel>: RecommendationsPresenter,
                                                                          BookListCellPresenter {

    // MARK: - Properties

    // MARK: RecommendationsPresenter protocol properties

    @Published
    private(set) var recommendations = [BookViewModel]()

    // MARK: Private properties

    private let model: Model
    private let updateQueue: DispatchQueue
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    /**
     Creates a presenter object.
     - Parameters:
        - recommendationsModel: Data providing object.
        - updateQueue: Queue on which presentation data is passed to view.
     */
    init(recommendationsModel: Model, updateQueue: DispatchQueue = .main) {
        self.model = recommendationsModel
        self.updateQueue = updateQueue

        bind(model: model)
    }

    // MARK: - Methods

    // MARK: BookListCellPresenter protocol methods

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
                self.recommendations = model
                    .recommendations
                    .map { $0.asViewModel(favorite: model.favoriteBookIDs.contains($0.id)) }
                    .filter { !$0.isFavorite }
        }
        .store(in: &cancellables)
    }

}

// MARK: -

/// The implementation of the Recommendations screen presenter that used for SwiftUI previews.
final class RecommendationsPreviewPresenter: RecommendationsPresenter, BookListCellPresenter {

    // MARK: - Properties

    // MARK: RecommendationsPresenter protocol properties

    var recommendations = [
        BookViewModel(authors: "J.R.R. Tolkien", id: "1", isFavorite: true, title: "The Lord of the Rings"),
        BookViewModel(authors: "Michael Bond", id: "2", isFavorite: true, title: "Paddington Pop-Up London"),
        BookViewModel(authors: "J.K. Rowling",
                      id: "3",
                      isFavorite: true,
                      title: "Harry Potter and the Sorcecer's Stone"),
        BookViewModel(authors: "George R.R. Martin", id: "4", isFavorite: true, title: "A Game of Thrones"),
        BookViewModel(authors: "Frank Herbert", id: "5", isFavorite: true, title: "Dune I"),
        BookViewModel(authors: "Mikhail Bulgakov", id: "6", isFavorite: true, title: "The Master and Margarita"),
        BookViewModel(authors: "Alan Moore", id: "7", isFavorite: true, title: "Watchmen"),
        BookViewModel(authors: "Steve McConnell", id: "8", isFavorite: true, title: "Code Complete"),
        BookViewModel(authors: "Jane Austen", id: "9", isFavorite: true, title: "Pride and Prejudice"),
        BookViewModel(authors: "Martin Fowler",
                      id: "10",
                      isFavorite: true,
                      title: "Refactoring: Improving the Design of Existing Code"),
        BookViewModel(authors: "Stephen King", id: "11", isFavorite: true, title: "The Shining"),
        BookViewModel(authors: "Hannah Arendt",
                      id: "12",
                      isFavorite: true,
                      title: "Eichmann in Jerusalem: A Report on the Banality of Evil"),
        BookViewModel(authors: "Fyodor Dostoyevsky", id: "13", isFavorite: true, title: "The Idiot"),
        BookViewModel(authors: "Ken Kesey", id: "14", isFavorite: true, title: "Sometimes a Great Notion"),
        BookViewModel(authors: "Haruki Murakami", id: "15", isFavorite: true, title: "The Wind-Up Bird Chronicle")
    ]

    // MARK: - Methods

    // MARK: BookListCellPresenter protocol methods

    func toggleFavoriteState(bookID: String) {
        // Do nothing.
    }

}
