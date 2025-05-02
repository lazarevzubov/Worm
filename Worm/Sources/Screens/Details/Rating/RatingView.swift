//
//  RatingView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 23.4.2025.
//

import SwiftUI

/// View displaying a rating.
struct RatingView: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        HStack(spacing: 4.0) {
            ForEach(viewModel.units, id: \.self) {
                Image(systemName: imageName(for: $0))
                    .accessibilityHidden(true)
            }
        }
            .accessibilityElement()
            .accessibilityLabel("\(viewModel.rating, specifier: "%.1f") out of \(viewModel.units.count) stars")
    }

    // MARK: Private properties

    private let viewModel: RatingViewModel

    // MARK: - Initialization

    /// Creates a view displaying a rating.
    /// - Parameters:
    ///   - viewModel: Presentation logic of the view.
    init(viewModel: RatingViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Methods

    // MARK: Private methods

    private func imageName(for unit: RatingViewModel.RatingUnit) -> String {
        switch unit {
            case .full:
                "star.fill"
            case .halfEmpty:
                "star.leadinghalf.filled"
            case .empty:
                "star"
        }
    }

}

#if DEBUG

// MARK: -

#Preview {
    HStack {
        Text("0.0:")
        RatingView(viewModel: RatingViewModel(rating: .zero))
    }
        .padding([.bottom])
    HStack {
        Text("0.1:")
        RatingView(viewModel: RatingViewModel(rating: 0.1))
    }
        .padding([.bottom])
    HStack {
        Text("0.4:")
        RatingView(viewModel: RatingViewModel(rating: 0.4))
    }
        .padding([.bottom])
    HStack {
        Text("0.5:")
        RatingView(viewModel: RatingViewModel(rating: 0.5))
    }
        .padding([.bottom])
    HStack {
        Text("0.6:")
        RatingView(viewModel: RatingViewModel(rating: 0.6))
    }
        .padding([.bottom])
    HStack {
        Text("0.9:")
        RatingView(viewModel: RatingViewModel(rating: 0.9))
    }
        .padding([.bottom])
    HStack {
        Text("1.0:")
        RatingView(viewModel: RatingViewModel(rating: 1.0))
    }
        .padding([.bottom])
    HStack {
        Text("2.0:")
        RatingView(viewModel: RatingViewModel(rating: 2.0))
    }
        .padding([.bottom])
    HStack {
        Text("3.0:")
        RatingView(viewModel: RatingViewModel(rating: 3.0))
    }
        .padding([.bottom])
    HStack {
        Text("4.0:")
        RatingView(viewModel: RatingViewModel(rating: 4.0))
    }
        .padding([.bottom])
    HStack {
        Text("5.0:")
        RatingView(viewModel: RatingViewModel(rating: 5.0))
    }
        .padding([.bottom])
}

#endif
