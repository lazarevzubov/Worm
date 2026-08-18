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
            BookInfoView(book: book)
            Spacer()
            Button { viewModel.toggleFavoriteStateOfBook(withID: book.id) } label: {
                Image(
                    systemName: book.favorite
                        ? "heart.fill"
                        : "heart"
                )
                    .foregroundColor(.primary)
                    .frame(minSize: 44.0)
                    .contentShape(.rect)
            }
                .accessibilityElement()
                .accessibility(label: makeFavoriteButtonAccessibilityLabel(for: book))
        }
            .buttonStyle(.plain)
            .contentShape(.rect)
            .onTapGesture { onRowTap?() }
    }

    // MARK: Private properties

    private let book: BookViewModel
    private let onRowTap: (() -> Void)?
    private let viewModel: BookListCellViewModel

    // MARK: - Initialization

    /// Creates a cell's displaying representation.
    /// - Parameters:
    ///   - book: A book data for a visual representation.
    ///   - viewModel: The presentation logic of the book table cell.
    ///   - onRowTap: Called when the cell is tapped anywhere outside the favorite button.
    init(book: BookViewModel, viewModel: BookListCellViewModel, onRowTap: (() -> Void)? = nil) {
        self.book = book
        self.viewModel = viewModel
        self.onRowTap = onRowTap
    }

    // MARK: - Methods

    // MARK: Private methods

    private func makeFavoriteButtonAccessibilityLabel(for book: BookViewModel) -> Text {
        book.favorite
            ? Text(
                "\(book.title) favorite checked", comment: "Accessibility label for a book and its favorite status"
            )
            : Text(
                "\(book.title) favorite unchecked", comment: "Accessibility label for a book and its favorite status"
            )
    }

}
