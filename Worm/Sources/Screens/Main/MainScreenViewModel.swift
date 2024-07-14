//
//  MainScreenViewModel.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 13.7.2024.
//

import Combine

/// The presentation logic of the main screen.
protocol MainScreenViewModel: ObservableObject {

    // MARK: - Properties

    /// The current search query.
    var query: String { get set }

}

#if DEBUG

// MARK: -

final class MainScreenPreviewViewModel: MainScreenViewModel {

    // MARK: - Properties

    // MARK: MainScreenViewModel protocol properties

    var query = ""

}

#endif
