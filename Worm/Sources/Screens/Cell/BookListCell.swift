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
            Button(action: { viewModel.toggleFavoriteState(bookID: book.id) }) {
                Image(systemName: (book.isFavorite 
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

    /**
     Creates a cell's displaying representation.
     - Parameters:
        - book: A book data for a visual representation.
        - viewModel: The presentation logic of the book table cell.
     */
    init(book: BookViewModel, viewModel: BookListCellViewModel) {
        self.book = book
        self.viewModel = viewModel
    }

    // MARK: - Methods

    // MARK: Private methods

    private func makeCellAccessibilityLabel(for book: BookViewModel) -> Text {
        Text("\(book.authors) – \(book.title)")
    }

    private func makeFavoriteButtonAccessibilityLabel(for book: BookViewModel) -> Text {
        book.isFavorite
            ? Text(String(format: "SearchScreenFavoriteMarkCheckedHintFormat", book.title))
            : Text(String(format: "SearchScreenFavoriteMarkUncheckedHintFormat", book.title))
    }

}
