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
                .navigationTitle("Recommendations")
                .toolbarColorScheme(.light, for: .navigationBar)
                .toolbarBackground(Color(red: (190.0 / 255.0), green: (142.0 / 255.0), blue: (155.0 / 255.0)),
                                   for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarItems(trailing: EditButton())
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

    private func deleteItem(at indexSet: IndexSet) {
        indexSet.forEach { viewModel.block(recommendation: viewModel.recommendations[$0]) }
    }

}

// MARK: -

#if DEBUG

#Preview {
    RecommendationsView(viewModel: RecommendationsPreviewViewModel())
}

#endif
