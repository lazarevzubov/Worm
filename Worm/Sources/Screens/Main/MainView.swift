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

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        VStack {
            // TODO: Close on tap.
            SearchBar(text: $presenter.query, placeholder: "SearchScreenSearchFieldPlaceholder")
            List(presenter.books) { book in
                // TODO: Extract cell.
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
                    .accessibility(label: Text("\(book.authors) – \(book.title)"))
                    Spacer()
                    // TODO: Bind to State.
                    // TODO: Check accessibility.
                    Button(action: { self.presenter.toggleFavoriteState(bookID: book.id) }) {
                        Image(systemName: (book.favorite ? "heart.fill" : "heart"))
                            .foregroundColor(.primary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationBarTitle("SearchScreenTitle")
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

        // Complement: UIColor(red: (190.0 / 255.0), green: (142.0 / 255.0), blue: (155.0 / 255.0), alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = UIColor(red: (172.0 / 255.0),
                                                               green: (211.0 / 255.0),
                                                               blue: (214.0 / 255.0),
                                                               alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.black]
    }

}

// MARK: -

/// Produces the book search screen preview for Xcode.
struct MainView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { MainView(presenter: MainPreviewPresenter()) }

}
