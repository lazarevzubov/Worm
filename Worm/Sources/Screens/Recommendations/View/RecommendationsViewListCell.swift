//
//  RecommendationsViewListCell.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 15.7.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The visual representation of a cell of the Recommendations list.
struct RecommendationsViewListCell: View {

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
        }
        .buttonStyle(PlainButtonStyle())
        .listRowInsets(EdgeInsets())
    }

    // MARK: Private properties

    private let book: BookViewModel

    // MARK: - Initialization

    /**
     Creates a cell.
     - Parameter book: The corresponding to the cell book data for a visual representation.
     */
    init(book: BookViewModel) {
        self.book = book
    }

    // MARK: - Methods

    // MARK: Private methods

    private func makeCellAccessibilityLabel(for book: BookViewModel) -> Text {
        return Text("\(book.authors) – \(book.title)")
    }

}
