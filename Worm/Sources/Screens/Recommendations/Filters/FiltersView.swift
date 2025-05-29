//
//  FiltersView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.5.2025.
//  Copyright © 2025 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The view with a selector of filters.
struct FiltersView<ViewModel: FiltersViewModel>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
#if os(macOS)
        HStack {
            Spacer()
            Button("Close") { dismiss() }
                .padding()
        }
#endif
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100.0))], spacing: 20.0) {
            ForEach(RecommendationsFilter.allCases, id: \.self) { filterItem in
                Button {
                    withAnimation {
                        if viewModel.appliedFilters.contains(filterItem) {
                            viewModel.appliedFilters.removeAll { $0 == filterItem }
                        } else {
                            viewModel.appliedFilters.append(filterItem)
                        }
                    }
                } label: {
                    switch filterItem {
                        case .topRated:
                            Text("Top rated")
                    }
                }
                .`if`(viewModel.appliedFilters.contains(filterItem)) {
                    $0
                        .buttonStyle(.borderedProminent)
                } `else`: {
                    $0
                        .buttonStyle(.bordered)
                }
                .buttonBorderShape(.capsule)
            }
        }
            .padding(32.0)
#if os(iOS)
            .overlay {
                GeometryReader {
                    Color.clear.preference(key: InnerHeightPreferenceKey.self, value: $0.size.height)
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { sheetHeight = $0 }
            .presentationDetents([.height(sheetHeight)])
#endif
            .presentationDragIndicator(.visible)
    }

    // MARK: Private properties

    @Environment(\.dismiss)
    private var dismiss
    @State
    private var sheetHeight = CGFloat.zero
    @ObservedObject
    private var viewModel: ViewModel

    // MARK: - Initialization

    /// Creates the view.
    /// - Parameter viewModel: Object responsible for the presentation logic of the recommendations filters.
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: -

    private struct InnerHeightPreferenceKey: PreferenceKey {

        // MARK: - Properties

        // MARK: PreferenceKey protocol properties

        static var defaultValue: CGFloat { .zero }

        // MARK: - Methods

        // MARK: PreferenceKey protocol methods

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }

    }

}

#if DEBUG

// MARK: -

#Preview { FiltersView(viewModel: RecommendationsPreviewViewModel()) }

#endif
