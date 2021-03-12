//
//  RecommendationsView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 28.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The visual representation of the Recommendations screen.
struct RecommendationsView<Presenter: RecommendationsPresenter>: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationView {
            List {
                ForEach(presenter.recommendations) { book in
                    Button(action: { detailsPresented = true }) { BookListCell(book: book, presenter: presenter) }
                        .sheet(isPresented: $detailsPresented) {
                            BookDetailsView(presenter: presenter.makeDetailsPresenter(for: book))
                        }
                }
                .onDelete(perform: deleteItem)
            }
            .animation(.easeIn)
            .listStyle(PlainListStyle())
            .navigationTitle("RecommendationsScreenTitle")
            .navigationBarItems(trailing: EditButton())
            .onAppear { configureNavigationBar() }
        }
    }

    // MARK: Private properties

    @State
    private var detailsPresented = false
    @ObservedObject
    private var presenter: Presenter

    // MARK: - Initialization

    /**
     Creates the view object.
     - Parameter presenter: The object responsible for Recommendations screen presentation logic.
     */
    init(presenter: Presenter) {
        self.presenter = presenter
    }

    // MARK: - Methods

    // MARK: Private methods

    private func configureNavigationBar() {
        UINavigationBar.appearance().backgroundColor = UIColor(red: (190.0 / 255.0),
                                                               green: (142.0 / 255.0),
                                                               blue: (155.0 / 255.0),
                                                               alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.black]
    }

    private func deleteItem(at indexSet: IndexSet) {
        indexSet.forEach { presenter.block(recommendation: presenter.recommendations[$0]) }
    }

}

// MARK: -

/// Produces the Recommendations screen preview for Xcode.
struct RecommendationsView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { RecommendationsView(presenter: RecommendationsPreviewPresenter()) }

}
