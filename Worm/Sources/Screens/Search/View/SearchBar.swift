//
//  SearchBar.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 21.10.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The search bar view
struct SearchBar: View {

    // MARK: - Properties

    /// The search text binding.
    @Binding
    var text: String

    // MARK: View protocol properties

    var body: some View {
        HStack(spacing: 8.0) {
            Spacer()
            TextField("SearchScreenSearchFieldPlaceholder", text: $text)
                .padding(7.0)
                .padding(.horizontal, 25.0)
                .background(Color(.systemGray6))
                .cornerRadius(8.0)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8.0)
                        if editing {
                            Button { text = "" } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8.0)
                            }
                                .accessibility(identifier: "cancelSearchButton")
                        }
                    }
                )
                    .onTapGesture { editing = true }
                    .transition(.move(edge: .trailing))
                    .animation(.default, value: editing)
                    .accessibility(label: Text("SearchScreenSearchFieldPlaceholder"))
            if editing {
                Button {
                    editing = false
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil,
                                                    from: nil,
                                                    for: nil)
                } label: { Text("CancelButtonTitle") }
                    .padding(.trailing, 8.0)
                    .transition(.move(edge: .trailing))
                    .animation(.default, value: editing)
            }
        }
    }

    // MARK: Private properties

    @State
    private var editing = false

}

#if DEBUG

// MARK: -

#Preview {
    SearchBar(text: .constant(""))
}

#endif
