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
            Button("Close") { dismiss() }
                .padding()
        }
        Spacer()
        if let image = viewModel.image { // TODO: Update if downloaded later.
#if os(iOS)
            Image(uiImage: image)
                .padding(.bottom)
#elseif os(macOS)
            Image(nsImage: image)
                .padding(.bottom)
#endif
        }
        Text(viewModel.title)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        Text(viewModel.authors)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        Text(viewModel.description)
            .font(.caption)
            .multilineTextAlignment(.center)
            .padding(
                [.top,
                 .horizontal]
            )
        Spacer()
    }

    // MARK: Private properties

    @Environment(\.dismiss) 
    private var dismiss
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the view.
    /// - Parameter viewModel: The presentation data provider.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

#if DEBUG

// MARK: -

#Preview { BookDetailsView(viewModel: BookDetailsPreviewViewModel()) }

#endif
