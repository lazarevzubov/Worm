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

}
