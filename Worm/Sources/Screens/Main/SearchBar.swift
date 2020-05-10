//
//  SearchBar.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 22.4.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {

    final class Coordinator: NSObject, UISearchBarDelegate {

        // MARK: - Properties

        @Binding
        var text: String

        // MARK: - Initialization

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

    var placeholder = ""
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

        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
}
