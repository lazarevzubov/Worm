//
//  RecommendationsView.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 28.6.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

// TODO: HeaderDoc.
struct RecommendationsView: View {

    // TODO: Check accessibility.

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        NavigationView {
            Text("Recommendtations coming soon!")
                .navigationBarTitle("RecommendationsScreenTitle")
        }
        .onAppear {
            self.configureNavigationBar()
        }
    }

    // MARK: Private properties

    private let presenter: RecommendationsPresenter

    // MARK: - Initialization

    init(presenter: RecommendationsPresenter) {
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

}

// MARK: -

/// Produces the book search screen preview for Xcode.
struct RecommendationsView_Previews: PreviewProvider {

    // MARK: - Properties

    // MARK: PreviewProvider protocol properties

    static var previews: some View { RecommendationsView(presenter: RecommendationsPreviewPresenter()) }

}

