//
//  SearchViewModel.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 13.7.2024.
//

import Combine

/// The presentation logic of the book search screen.
protocol SearchViewModel: BookListCellViewModel, BookDetailsPresentable, ObservableObject {

    // MARK: - Properties

    /// The list of books corresponding to the current search query.
    var books: [BookViewModel] { get }
    /// Whether the onboarding about the recommendations has been already shown to the user.
    var recommendationsOnboardingShown: Bool { get set }
    /// Whether the onboarding about the searching has been already shown to the user.
    var searchOnboardingShown: Bool { get set }

}

#if DEBUG

// MARK: -

final class SearchPreviewViewModel: SearchViewModel, BookListCellViewModel {

    // MARK: - Properties

    // MARK: SearchViewModel protocol properties

    var query = ""
    var recommendationsOnboardingShown = false
    var searchOnboardingShown = false
    private(set) var books = [
        BookViewModel(
            id: "1",
            authors: "J.R.R. Tolkien",
            title: "The Lord of the Rings",
            description: "A sensitive hobbit unexpectedly saves the situation.",
            imageURL: nil,
            rating: nil,
            favorite: false
        ),
        BookViewModel(
            id: "2",
            authors: "Michael Bond",
            title: "Paddington Pop-Up London",
            description: "A cute pop-up book about London, the capital of The United Kingdom.",
            imageURL: nil,
            rating: "0.12",
            favorite: false
        ),
        BookViewModel(
            id: "3",
            authors: "J.K. Rowling",
            title: "Harry Potter and the Sorcecer's Stone",
            description: "Another sensitive teenager saves the day thank to his friends.",
            imageURL: nil,
            rating: "1.23",
            favorite: false
        ),
        BookViewModel(
            id: "4",
            authors: "George R.R. Martin",
            title: "A Game of Thrones",
            description: "Caligula with magic and dragons.",
            imageURL: nil,
            rating: "2.34",
            favorite: false
        ),
        BookViewModel(
            id: "5",
            authors: "Frank Herbert",
            title: "Dune I",
            description: "A good example of why immigrants can be useful to a country (or a planet).",
            imageURL: nil,
            rating: "3.45",
            favorite: false
        ),
        BookViewModel(
            id: "6",
            authors: "Mikhail Bulgakov",
            title: "The Master and Margarita",
            description: "An exception that proves that some books from the public school program are actually good.",
            imageURL: nil,
            rating: "4.56",
            favorite: false
        ),
        BookViewModel(
            id: "7",
            authors: "Alan Moore",
            title: "Watchmen",
            description: "Aging superheroes with psychological issues face the demons of their past.",
            imageURL: nil,
            rating: nil,
            favorite: false
        ),
        BookViewModel(
            id: "8",
            authors: "Steve McConnell",
            title: "Code Complete",
            description: "How to make your code a bit less shitty.",
            imageURL: nil,
            rating: "1.23",
            favorite: false
        ),
        BookViewModel(
            id: "9",
            authors: "Jane Austen",
            title: "Pride and Prejudice",
            description: "More than just a love story.",
            imageURL: nil,
            rating: "2.34",
            favorite: false
        ),
        BookViewModel(
            id: "10",
            authors: "Martin Fowler",
            title: "Refactoring: Improving the Design of Existing Code",
            description: "A step-by-step guide how to make your code bearable to work with.",
            imageURL: nil,
            rating: "3.45",
            favorite: false
        ),
        BookViewModel(
            id: "11",
            authors: "Stephen King",
            title: "The Shining",
            description: "How the family can drive a person crazy, when they are locked up together.",
            imageURL: nil,
            rating: "4.56",
            favorite: false
        ),
        BookViewModel(
            id: "12",
            authors: "Hannah Arendt",
            title: "Eichmann in Jerusalem: A Report on the Banality of Evil",
            description: "How the Jew made their situation even worse during WWII.",
            imageURL: nil,
            rating: nil,
            favorite: false
        ),
        BookViewModel(
            id: "13",
            authors: "Fyodor Dostoyevsky",
            title: "The Idiot",
            description: "A book about a nice person in the world of idiots (i.e., the real world).",
            imageURL: nil,
            rating: "2.34",
            favorite: false
        ),
        BookViewModel(
            id: "14",
            authors: "Ken Kesey",
            title: "Sometimes a Great Notion",
            description: "A story that proves you must stay away of your family after you grow up.",
            imageURL: nil,
            rating: "3.45",
            favorite: false
        ),
        BookViewModel(
            id: "15",
            authors: "Haruki Murakami",
            title: "The Wind-Up Bird Chronicle",
            description: "A half anime-pervert, half meditating phantasy.",
            imageURL: nil,
            rating: "4.56",
            favorite: false
        )
    ]

    // MARK: - Methods

    // MARK: SearchViewModel protocol methods

    func toggleFavoriteStateOfBook(withID id: String) {
        books = books.map {
            BookViewModel(
                id: $0.id,
                authors: $0.authors,
                title: $0.title,
                description: $0.description,
                imageURL: nil,
                rating: $0.rating,
                favorite: ($0.id == id)
                    ? !$0.favorite
                    : $0.favorite
            )
        }
    }

    func makeDetailsViewModel(for favorite: BookViewModel) -> some BookDetailsViewModel {
        BookDetailsPreviewViewModel()
    }

}

#endif
