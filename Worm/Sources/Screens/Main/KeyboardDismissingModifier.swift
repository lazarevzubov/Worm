//
//  KeyboardDismissingModifier.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 24.5.2020.
//  Copyright © 2020 Nikita Lazarev-Zubov. All rights reserved.
//

import SwiftUI

/// The modifier to a view which forces keyboard to dismiss on tap.
struct DismissingKeyboard: ViewModifier {

    // MARK: - Methods

    // MARK: ViewModifier protocol methods

    func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication
                .shared
                .connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .filter { $0.isKeyWindow }
                .first?
                .endEditing(true)
        }
    }

}
