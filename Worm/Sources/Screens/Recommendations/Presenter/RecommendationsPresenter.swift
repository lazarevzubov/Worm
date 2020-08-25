//
//  RecommendationsPresenter.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine
import Foundation
import GoodreadsService

// TODO: Marking favorites from this screen.
// TODO: Not displaying favorites.

// TODO: HeaderDoc.
protocol RecommendationsPresenter: ObservableObject {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var recommendations: [BookViewModel] { get }

    // MARK: - Methods

    // TODO: HeaderDoc.
    func onViewAppear()

}

// MARK: -

// TODO: HeaderDoc.
final class RecommendationsDefaultPresenter<Manager: RecommendationsManager>: RecommendationsPresenter {

    // MARK: - Properties

    // MARK: RecommendationsPresenter protocol properties

    @Published
    private(set) var recommendations = [BookViewModel]()

    // MARK: Private properties

    private let model: RecommendationsModel
    private let recommendationsManager: Manager
    private let updateQueue: DispatchQueue
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(model: RecommendationsModel, recommendationsManager: Manager, updateQueue: DispatchQueue = .main) {
        self.model = model
        self.recommendationsManager = recommendationsManager
        self.updateQueue = updateQueue
    }

    // MARK: - Methods

    // MARK: RecommendationsPresenter protocol methods

    func onViewAppear() {
        bind(recommendationsManager: recommendationsManager)
        updateFavoriteBooks()
    }

    // MARK: Private methods

    private func bind(recommendationsManager: Manager) {
        recommendationsManager
            .objectWillChange
            .receive(on: updateQueue)
            .sink { [weak self] _ in
                self?.objectWillChange.send()

                // FIXME: Favorite hardcoded-ness.
                self?.recommendations = recommendationsManager.recommendations.map { $0.asViewModel(favorite: true) }
        }
        .store(in: &cancellables)
    }

    private func updateFavoriteBooks() {
        // FIXME: Nested closures.
        model.favoriteBookIDs.forEach {
            model.getBook(by: $0) { [weak self] in
                $0?.similarBookIDs.forEach { self?.recommendationsManager.addRecommendation(id: $0) }
            }
        }
    }

}

// MARK: -

// TODO: HeaderDoc.
final class RecommendationsPreviewPresenter: RecommendationsPresenter {

    // MARK: - Properties

    // MARK: RecommendationsPresenter protocol properties

    var recommendations = [
        BookViewModel(authors: "J.R.R. Tolkien", favorite: true, id: "1", title: "The Lord of the Rings"),
        BookViewModel(authors: "Michael Bond", favorite: true, id: "2", title: "Paddington Pop-Up London"),
        BookViewModel(authors: "J.K. Rowling",
                      favorite: true,
                      id: "3",
                      title: "Harry Potter and the Sorcecer's Stone"),
        BookViewModel(authors: "George R.R. Martin", favorite: true, id: "4", title: "A Game of Thrones"),
        BookViewModel(authors: "Frank Herbert", favorite: true, id: "5", title: "Dune I"),
        BookViewModel(authors: "Mikhail Bulgakov", favorite: true, id: "6", title: "The Master and Margarita"),
        BookViewModel(authors: "Alan Moore", favorite: true, id: "7", title: "Watchmen"),
        BookViewModel(authors: "Steve McConnell", favorite: true, id: "8", title: "Code Complete"),
        BookViewModel(authors: "Jane Austen", favorite: true, id: "9", title: "Pride and Prejudice"),
        BookViewModel(authors: "Martin Fowler",
                      favorite: true,
                      id: "10",
                      title: "Refactoring: Improving the Design of Existing Code"),
        BookViewModel(authors: "Stephen King", favorite: true, id: "11", title: "The Shining"),
        BookViewModel(authors: "Hannah Arendt",
                      favorite: true,
                      id: "12",
                      title: "Eichmann in Jerusalem: A Report on the Banality of Evil"),
        BookViewModel(authors: "Fyodor Dostoyevsky", favorite: true, id: "13", title: "The Idiot"),
        BookViewModel(authors: "Ken Kesey", favorite: true, id: "14", title: "Sometimes a Great Notion"),
        BookViewModel(authors: "Haruki Murakami", favorite: true, id: "15", title: "The Wind-Up Bird Chronicle")
    ]

    // MARK: - Methods

    // MARK: RecommendationsPresenter protocol methods

    func onViewAppear() {
        // Do nothing.
    }

}
