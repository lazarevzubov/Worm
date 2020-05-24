//
//  MainView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import GoodreadsService
import SwiftUI

/// The book search screen.
struct MainView<Presenter: MainPresenter>: View {

    // TODO: LocalizedStringKeys.

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        VStack {
            SearchBar(placeholder: "Search books", text: $presenter.query)
            List(presenter.books) { book in
                VStack(alignment: .leading) {
                    Text(book.authors.joined(separator: ", "))
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
                .accessibility(label: Text("\(book.authors.joined(separator: ", ")) – \(book.title)"))
            }
        }
        .navigationBarTitle("Search")
    }

    // MARK: Private properties

    @ObservedObject
    private var presenter: Presenter

    // MARK: - Initialization

    /**
     Creates the screen.
     - Parameter presenter: The presentation logic handler.
     */
    init(presenter: Presenter) {
        self.presenter = presenter
    }

}

// MARK: -

/// Produces the book search screen preview for Xcode.
struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View {MainView(presenter: MainPreviewPresenter()) }

}

// MARK: - Identifiable

extension Book: Identifiable { }
