//
//  BookDetailsView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 16.2.2021.
//

import SwiftUI

/// The view with detailed information on a book.
struct BookDetailsView<ViewModel: BookDetailsViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        HStack {
            Spacer()
            Button("Close") { presented.toggle() }
                .padding()
        }
        Spacer()
        if let image = viewModel.image { // TODO: Update if downloaded later.
            Image(uiImage: image)
            Spacer()
        }
        Text(viewModel.title)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        Text(viewModel.authors)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding([.top, .horizontal])
        Spacer()
    }

    // MARK: Private properties

    @Binding
    private var presented: Bool
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the view.
    /// - Parameters:
    ///   - viewModel: The presentation data provider.
    ///   - presented: A binding that indicates whether the view is presented on the screen.
    init(viewModel: ViewModel, presented: Binding<Bool>) {
        self.viewModel = viewModel
        _presented = presented
    }

}

#if DEBUG

// MARK: -

#Preview { BookDetailsView(viewModel: BookDetailsPreviewViewModel(), presented: .constant(true)) }

#endif
