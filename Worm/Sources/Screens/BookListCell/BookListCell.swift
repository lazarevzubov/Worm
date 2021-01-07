//
//  BookListCell.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 6.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The table call contaning a book info.
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
            Button(action: {
                    presenter.toggleFavoriteState(bookID: book.id)
            }) {
                Image(systemName: (book.isFavorite ? "heart.fill" : "heart")).foregroundColor(.primary)
            }
            .accessibilityElement()
            .accessibility(label: makeFavoriteButtonAccessibilityLabel(for: book))
        }
        .buttonStyle(PlainButtonStyle())
        .listRowInsets(EdgeInsets())
    }

    // MARK: Private properties

    private let book: BookViewModel
    private let presenter: BookListCellPresenter

    // MARK: - Initialization

    /**
     Creates a cell's displaying representation.
     - Parameters:
        - book: A book data for a visual representation.
        - presenter: The presentation logic of the book table cell.
     */
    init(book: BookViewModel, presenter: BookListCellPresenter) {
        self.book = book
        self.presenter = presenter
    }

    // MARK: - Methods

    // MARK: Private methods

    private func makeCellAccessibilityLabel(for book: BookViewModel) -> Text {
        return Text("\(book.authors) – \(book.title)")
    }

    private func makeFavoriteButtonAccessibilityLabel(for book: BookViewModel) -> Text {
        return book.isFavorite
            ? Text(String(format: "SearchScreenFavoriteMarkCheckedHintFormat", book.title))
            : Text(String(format: "SearchScreenFavoriteMarkUncheckedHintFormat", book.title))
    }

}
