//
//  FiltersViewModel.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 29.5.2025.
//  Copyright © 2025 Nikita Lazarev-Zubov. All rights reserved.
//

import Combine

/// Possible filters that could be applied to book recommendations.
enum RecommendationsFilter: CaseIterable {

    /// Filters out books that have low ratings.
    case topRated

}

// MARK: -

/// Object responsible for the presentation logic of the recommendations filters.
@MainActor
protocol FiltersViewModel: ObservableObject {

    // MARK: - Properties

    /// Filters that are applied to book recommendations.
    var appliedFilters: [RecommendationsFilter] { get set }
    
}
