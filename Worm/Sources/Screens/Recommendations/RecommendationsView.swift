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
        ZStack {
            List {
                ForEach(viewModel.recommendations) { book in
                    Button { selectedBook = book } label: { BookListCell(book: book, viewModel: viewModel) }
                        .buttonStyle(.plain)
                }
                    .onDelete(perform: deleteItem)
            }
                .animation(.easeIn, value: viewModel.recommendations)
                .listStyle(.plain)
            if !viewModel.onboardingShown {
                VStack {
                    OnboardingView(
                        text: "Recommendations are shown in the order of their relevance and update as you turn some of them down or mark more books as favourites.",
                        color: .search
                    )
                        .accessibilityIdentifier("OnboardingLabel")
                    Spacer()
                }
                    .onTapGesture { viewModel.onboardingShown = true }
            }
        }
            .animation(.default, value: viewModel.onboardingShown)
            .sheet(item: $selectedBook) { BookDetailsView(viewModel: viewModel.makeDetailsViewModel(for: $0)) }
    }

    // MARK: Private properties

    @State
    private var selectedBook: BookViewModel?
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
        indexSet.forEach { viewModel.blockRecommendation(viewModel.recommendations[$0]) }
    }

}

// MARK: -

#if DEBUG

#Preview { RecommendationsView(viewModel: RecommendationsPreviewViewModel()) }

#endif
