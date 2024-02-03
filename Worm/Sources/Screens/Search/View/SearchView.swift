//
//  SearchView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 13.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The book search screen.
struct SearchView<ViewModel: SearchViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                Spacer()
                HStack {
                    SearchBar(text: $viewModel.query)
                    Spacer(minLength: 16.0)
                }
                List(viewModel.books) { book in
                    Button { detailsPresented = true } label: { BookListCell(book: book, viewModel: viewModel) }
                        .sheet(isPresented: $detailsPresented) {
                            BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: book),
                                            presented: $detailsPresented)
                        }
                }
                    .listStyle(.plain)
            }
                .navigationTitle("SearchScreenTitle")
                .onAppear { configureNavigationBar() }
        }
    }

    // MARK: Private properties

    @State
    private var detailsPresented = false
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the screen.
    /// - Parameter viewModel: The presentation logic handler.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Methods

    // MARK: Private methods

    private func configureNavigationBar() {
        UINavigationBar.appearance().backgroundColor = UIColor(red: (172.0 / 255.0),
                                                               green: (211.0 / 255.0),
                                                               blue: (214.0 / 255.0),
                                                               alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.black]
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}

#if DEBUG

// MARK: -

#Preview {
    SearchView(viewModel: SearchPreviewViewModel())
}

#endif
