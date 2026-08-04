//
//  View.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 7.7.2024.
//

import SwiftUI

extension View {

    // MARK: - Methods

    /// Shows a standard alert reporting that a change couldn't be saved, while the given condition is `true`.
    /// - Parameters:
    ///   - isPresented: Whether the alert is shown.
    ///   - titleKey: The alert's title.
    ///   - messageKey: The alert's message.
    ///   - buttonKey: The label of the button that dismisses the alert.
    /// - Returns: The view with the alert attached.
    func errorAlert(
        _ isPresented: Binding<Bool>,
        titleKey: LocalizedStringKey = "Something Went Wrong",
        messageKey: LocalizedStringKey = "Couldn't save your changes. Please try again.",
        buttonKey: LocalizedStringKey = "OK"
    ) -> some View {
        alert(titleKey, isPresented: isPresented) {
            Button(buttonKey) { isPresented.wrappedValue = false }
        } message: {
            Text(messageKey)
        }
    }

    /// Positions this view within an invisible frame having the specified size constraints.
    /// - Parameters:
    ///   - minSize: The minimum width and height of the resulting frame.
    ///   - idealWidth: The ideal width of the resulting frame.
    ///   - maxWidth: The maximum width of the resulting frame.
    ///   - idealHeight: The ideal height of the resulting frame.
    ///   - maxHeight: The maximum height of the resulting frame.
    ///   - alignment: The alignment of this view inside the resulting frame. Note that most alignment values have no
    ///     apparent effect when the size of the frame happens to match that of this view.
    /// - Returns: A view with flexible dimensions given by the call’s non-`nil` parameters.
    @inlinable
    nonisolated public func frame(
        minSize: CGFloat,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        frame(
            minWidth: minSize,
            idealWidth: idealWidth,
            maxWidth: maxWidth,
            minHeight: minSize,
            idealHeight: idealHeight,
            maxHeight: maxHeight,
            alignment: alignment
        )
    }

}
