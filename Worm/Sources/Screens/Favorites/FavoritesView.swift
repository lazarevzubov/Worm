//
//  FavoritesView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 11.1.2021.
//  Copyright © 2021 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The visual representation of the Favorites screen.
struct FavoritesView<ViewModel: FavoritesViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationView {
            List(viewModel.favorites) { book in
                Button { detailsPresented = true } label: { BookListCell(book: book, viewModel: viewModel) }
                    .sheet(isPresented: $detailsPresented) {
                        BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: book),
                                        presented: $detailsPresented)
                    }
            }
                .animation(.easeIn, value: viewModel.favorites)
                .navigationTitle("FavoritesScreenTitle")
                .onAppear { configureNavigationBar() }
        }
    }

    // MARK: Private properties

    @State
    private var detailsPresented = false
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the view.
    /// - Parameter viewModel: The object responsible for Favorites screen presentation logic.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
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

#if DEBUG

#Preview {
    FavoritesView(viewModel: FavoritesPreviewsViewModel())
}

#endif
