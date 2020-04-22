//
//  MainModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 20.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService

// TODO: HeaderDoc.

protocol MainModel {

    // MARK: - Properties

    var books: [Book] { get }

}

// MARK: -

struct MainViewDefaultModel: MainModel {

    // MARK: - Properties

    // MARK: MainViewModel protocol properties

    private(set) var books = [Book]()

}

// MARK: -

struct MainViewPreviewModel: MainModel {

    // MARK: - Properties

    // MARK: MainViewModel protocol properties

    var books: [Book] {
        return [Book(authors: ["J.R.R. Tolkien"], title: "The Lord of the Rings", id: "1"),
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

}
