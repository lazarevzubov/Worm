//
//  RecommendationsView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 28.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The visual representation of the Recommendations screen.
struct RecommendationsView<ViewModel: RecommendationsViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.recommendations) { book in
                    Button { detailsPresented = true } label: { BookListCell(book: book, viewModel: viewModel) }
                        .sheet(isPresented: $detailsPresented) {
                            BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: book),
                                            presented: $detailsPresented)
                        }
                }
                    .onDelete(perform: deleteItem)
            }
                .animation(.easeIn, value: viewModel.recommendations)
                .listStyle(.plain)
                .navigationTitle("RecommendationsScreenTitle")
                .navigationBarItems(trailing: EditButton())
                .onAppear { configureNavigationBar() }
        }
    }

    // MARK: Private properties

    @State
    private var detailsPresented = false
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the view object.
    /// - Parameter viewModel: The object responsible for Recommendations screen presentation logic.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Methods

    // MARK: Private methods

    private func configureNavigationBar() {
        UINavigationBar.appearance().backgroundColor = UIColor(red: (190.0 / 255.0),
                                                               green: (142.0 / 255.0),
                                                               blue: (155.0 / 255.0),
                                                               alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.black]
    }

    private func deleteItem(at indexSet: IndexSet) {
        indexSet.forEach { viewModel.block(recommendation: viewModel.recommendations[$0]) }
    }

}

// MARK: -

/// Produces the Recommendations screen preview for Xcode.
struct RecommendationsView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View {
        RecommendationsView(viewModel: RecommendationsPreviewViewModel())
    }

}
