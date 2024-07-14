//
//  View.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 7.7.2024.
//

import SwiftUI

extension View {

    /// Checks a condition and applies a view modification only if the condition is met.
    /// - Parameters:
    ///   - condition: The condition to met.
    ///   - transform: The view modification to apply.
    /// - Returns: The view with the applied modification, if the condition is met, or the original view, if it isn't.
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

}
