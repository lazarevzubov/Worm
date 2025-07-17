//
//  OnboardingView.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 13.5.2024.
//

import SwiftUI

/// A hint view suited for on-boarding.
struct OnboardingView: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        VStack(alignment: .trailing) {
            Image(systemName: "xmark")
                .padding([.vertical, .trailing], 4.0)
            Text(text, comment: localizationComment)
        }
            .fontWeight(.light)
            .foregroundStyle(Color.black)
            .padding(8.0)
            .background(color.cornerRadius(4.0))
            .padding(16.0)
    }

    // MARK: Private properties

    private let color: Color
    private let localizationComment: StaticString?
    private let text: LocalizedStringKey

    // MARK: - Initialization

    /// Creates a hint view suited for on-boarding.
    /// - Parameters:
    ///   - text: The localized  key used as the text of the hint.
    ///   - localizationComment: The comment for the text's localized key.
    ///   - color: The background color of the hint.
    init(text: LocalizedStringKey, localizationComment: StaticString? = nil, color: Color) {
        self.text = text
        self.localizationComment = localizationComment
        self.color = color
    }

}

#if DEBUG

// MARK: -

#Preview {
    OnboardingView(text: "Start by searching your favourite books and marking them as favourites.", color: .favorites)
}

#endif
