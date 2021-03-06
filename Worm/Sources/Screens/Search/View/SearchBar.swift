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
                            .frame(minWidth: 0.0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8.0)
                        if isEditing {
                            Button { text = "" }
                                label: {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8.0)
                                }
                                .accessibility(identifier: "cancelSearchButton")
                        }
                    }
                )
                .onTapGesture { isEditing = true }
                .transition(.move(edge: .trailing))
                .animation(.default)
                .accessibility(label: Text("SearchScreenSearchFieldPlaceholder"))
            if isEditing {
                Button {
                    isEditing = false
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil,
                                                    from: nil,
                                                    for: nil)
                } label: { Text("CancelButtonTitle") }
                .padding(.trailing, 8.0)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }

    // MARK: Private properties

    @State
    private var isEditing = false

}

// MARK: -

struct SearchBar_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { SearchBar(text: .constant("")) }

}
