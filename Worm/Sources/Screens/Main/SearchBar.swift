//
//  SearchBar.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 22.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The SwiftUI wrapper for the UIKit's `UISearchBar`.
struct SearchBar: UIViewRepresentable {

    /// Coordinates with the internal view object.
    final class Coordinator: NSObject, UISearchBarDelegate {

        // MARK: - Properties

        /// The current text of the search field.
        @Binding
        var text: String

        // MARK: - Initialization

        /**
         Creates the coordinator.
         - Parameter text: A binding to the search field text.
         */
        init(text: Binding<String>) {
            _text = text
        }

        // MARK: - Methods

        // MARK: UISearchBarDelegate protocol methods

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

    }

    // MARK: - Properties

    /// The placeholder of the search field text.
    var placeholder = ""
    /// The current text of the search field.
    @Binding
    var text: String

    // MARK: UIViewRepresentable protocol methods

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = placeholder
        searchBar.searchTextField.accessibilityIdentifier = "searchBar"

        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
}
