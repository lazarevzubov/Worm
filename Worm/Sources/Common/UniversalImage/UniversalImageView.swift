//
//  UniversalImageView.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 28.7.2024.
//

import SwiftUI

/// A view that displays an image.
struct UniversalImageView: View {

    // MARK: - Properties

    // MARK: View protocol properties

    var body: some View {
#if os(iOS)
        Image(uiImage: image)
#elseif os(macOS)
        Image(nsImage: image)
#endif
    }

    // MARK: Private properties

    private let image: UniversalImage

    // MARK: - Initialization

    /// Creates a SwiftUI image from an platform-independent image instance.
    /// - Parameter image: The platform-independent image to wrap with a SwiftUI `Image` instance.
    init(image: UniversalImage) {
        self.image = image
    }

}
