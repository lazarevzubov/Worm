//
//  FavoritesView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 11.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The visual representation of the Favorites screen.
struct FavoritesView<Presenter: FavoritesPresenter>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationView {
            List(presenter.favorites) { book in
                Button { detailsPresented = true }
                    label: { BookListCell(book: book, presenter: presenter) }
                    .sheet(isPresented: $detailsPresented) {
                        BookDetailsView(presenter: presenter.makeDetailsPresenter(for: book),
                                        presented: $detailsPresented)
                    }
            }
                .animation(.easeIn, value: presenter.favorites)
                .navigationTitle("FavoritesScreenTitle")
                .onAppear { configureNavigationBar() }
        }
    }

    // MARK: Private properties

    @State
    private var detailsPresented = false
    @ObservedObject
    private var presenter: Presenter

    // MARK: - Initialization

    /**
     Creates the view.
     - Parameter presenter: The object responsible for Favorites screen presentation logic.
     */
    init(presenter: Presenter) {
        self.presenter = presenter
    }

    // MARK: - Methods

    // MARK: Private methods

    private func configureNavigationBar() {
        UINavigationBar.appearance().backgroundColor = UIColor(red: (249.0 / 255.0),
                                                               green: (231.0 / 255.0),
                                                               blue: (132 / 255.0),
                                                               alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.black]
    }

}

// MARK: -

/// Produces the Favorites screen preview for Xcode.
struct FavoritesView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { FavoritesView(presenter: FavoritesPreviewPresenter()) }
    
}
