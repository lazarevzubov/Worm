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

// TODO: HeaderDoc.
protocol MainPresenter: ObservableObject {

    // MARK: - Properties

    // TODO: HeaderDoc.
    var query: String { get set }
    // TODO: HeaderDoc.
    var books: [Book] { get }

}

// MARK: -

// TODO: HeaderDoc.
final class MainDefaultPresenter<Model: MainModel>: MainPresenter {

    // MARK: - Properties

    // MARK: MainPresenter protocol properties

    var query: String = "" {
        didSet { model.searchBooks(by: query) }
    }
    @Published
    var books = [Book]()

    // MARK: Private methods

    private let model: Model
    private lazy var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(model: Model) {
        self.model = model
        bind(model: self.model)
    }

    // MARK: - Methods

    private func bind(model: Model) {
        // TODO: Find a way to test it.
        model
            .objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.objectWillChange.send()
                self.books = model.books
        }
        .store(in: &cancellables)
    }

}

// MARK: -

// TODO: HeaderDoc.
final class MainPreviewPresenter: MainPresenter {

    // MARK: - Properties

    // MARK: MainPresenter protocol properties

    var books: [Book] {
        [Book(authors: ["J.R.R. Tolkien"], title: "The Lord of the Rings", id: "1"),
         Book(authors: ["Michale Bond"], title: "Paddington Pop-Up London", id: "2"),
         Book(authors: ["J.K. Rowling"], title: "Harry Potter and the Sorcecer's Stone", id: "3"),
         Book(authors: ["George R.R. Martin"], title: "A Game of Thrones", id: "4"),
         Book(authors: ["Frank Herbert"], title: "Dune I", id: "5"),
         Book(authors: ["Mikhail Bulgakov"], title: "The Master and Margarita", id: "6"),
         Book(authors: ["Alan Moore"], title: "Watchmen", id: "7"),
         Book(authors: ["Steve McConnell"], title: "Code Complete", id: "8"),
         Book(authors: ["Jane Austen"], title: "Pride and Prejudice", id: "9"),
         Book(authors: ["Martin Fowler"],
              title: "Refactoring: Improving the Design of Existing Code",
              id: "10"),
         Book(authors: ["Stephen King"], title: "The Shining", id: "11"),
         Book(authors: ["Hannah Arendt"],
              title: "Eichmann in Jerusalem: A Report on the Banality of Evil",
              id: "12"),
         Book(authors: ["Fyodor Dostoyevsky"], title: "The Idiot", id: "13"),
         Book(authors: ["Ken Kesey"], title: "Sometimes a Great Notion", id: "14"),
         Book(authors: ["Haruki Murakami"], title: "The Wind-Up Bird Chronicle", id: "15")]
    }
    var query = ""

}
