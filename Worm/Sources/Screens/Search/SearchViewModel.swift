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
import GoodreadsService

final class SearchPreviewViewModel: SearchViewModel, BookListCellViewModel {

    // MARK: - Properties

    // MARK: SearchViewModel protocol properties

    var query = ""
    var recommendationsOnboardingShown = true
    var searchOnboardingShown = true
    private(set) var books = Book.previewFixtures.map { BookViewModel(book: $0, favorite: false) }

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
