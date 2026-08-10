//
//  BookInfoView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 10.8.2026.
//  Copyright © 2026 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The authors/title portion of a book list cell, shared by cells that do and don't offer favoriting.
struct BookInfoView: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
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
            .accessibility(label: makeAccessibilityLabel(for: book))
            .accessibilityAddTraits(.isButton)
    }

    // MARK: Private properties

    private let book: BookViewModel

    // MARK: - Initialization

    /// Creates the book info view.
    /// - Parameter book: A book data for a visual representation.
    init(book: BookViewModel) {
        self.book = book
    }

    // MARK: - Methods

    // MARK: Private methods

    private func makeAccessibilityLabel(for book: BookViewModel) -> Text {
        Text("\(book.authors) – \(book.title)", comment: "Accessibility label with a book title and authors")
    }

}
