//
//  OnboardingView.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 13.5.2024.
//

import SwiftUI

struct OnboardingView: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
        Text(text)
            .fontWeight(.light)
            .foregroundStyle(Color.black)
            .padding(8.0)
            .background(color.cornerRadius(4.0))
            .padding(16.0)
    }

    // MARK: Private properties

    private let color: Color
    private let text: String

    // MARK: - Initialization

    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }

}

// MARK: -

#Preview {
    OnboardingView(text: "Start by searching your favourite books and marking them as favourites.", color: .favorites)
}
