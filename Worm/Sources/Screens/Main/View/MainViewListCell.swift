//
//  MainViewListCell.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 6.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

// TODO: HeaderDoc.
struct MainViewListCell<Presenter: MainPresenter>: View {

    // TODO: Check accessibility.

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
            Button(action: { self.presenter.toggleFavoriteState(bookID: self.book.id) }) {
                Image(systemName: (book.favorite ? "heart.fill" : "heart"))
                    .foregroundColor(.primary)
            }
            .accessibilityElement()
            .accessibility(label: makeFavoriteButtonAccessibilityLabel(for: book))
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: Private properties

    private let book: BookViewModel
    private let presenter: Presenter

    // MARK: - Initialization

    // TODO: HeaderDoc.
    init(book: BookViewModel, presenter: Presenter) {
        self.book = book
        self.presenter = presenter
    }

    // MARK: - Methods

    // MARK: Private methods

    private func makeCellAccessibilityLabel(for book: BookViewModel) -> Text {
        return Text("\(book.authors) – \(book.title)")
    }

    private func makeFavoriteButtonAccessibilityLabel(for book: BookViewModel) -> Text {
        return Text("\(book.title) favorite \((book.favorite ? "checked" : "unchecked"))")
    }

}
