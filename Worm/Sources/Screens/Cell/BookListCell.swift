//
//  BookListCell.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 6.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The table call containing a book info.
struct BookListCell: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.authors)
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                    .accessibility(hidden: true)
                Text(book.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .accessibility(hidden: true)
            }
                .accessibilityElement()
                .accessibility(label: makeCellAccessibilityLabel(for: book))
            Spacer()
            Button { viewModel.toggleFavoriteStateOfBook(withID: book.id) } label: {
                Image(systemName: (book.favorite
                                       ? "heart.fill"
                                       : "heart"))
                    .foregroundColor(.primary)
            }
                .accessibilityElement()
                .accessibility(label: makeFavoriteButtonAccessibilityLabel(for: book))
        }
            .buttonStyle(.plain)
    }

    // MARK: Private properties

    private let book: BookViewModel
    private let viewModel: BookListCellViewModel

    // MARK: - Initialization

    /// Creates a cell's displaying representation.
    /// - Parameters:
    ///   - book: A book data for a visual representation.
    ///   - viewModel: The presentation logic of the book table cell.
    init(book: BookViewModel, viewModel: BookListCellViewModel) {
        self.book = book
        self.viewModel = viewModel
    }

    // MARK: - Methods

    // MARK: Private methods

    private func makeCellAccessibilityLabel(for book: BookViewModel) -> Text {
        Text("\(book.authors) – \(book.title)", comment: "Accessibility label with a book title and authors")
    }

    private func makeFavoriteButtonAccessibilityLabel(for book: BookViewModel) -> Text {
        book.favorite
            ? Text(
                "\(book.title) favourite checked", comment: "Accessibility label for a book and its favourite status"
            )
            : Text(
                "\(book.title) favourite unchecked", comment: "Accessibility label for a book and its favourite status"
            )
    }

}
