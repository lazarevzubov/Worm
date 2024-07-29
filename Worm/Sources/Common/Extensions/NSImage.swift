//
//  NSImage.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 28.7.2024.
//

#if os(macOS)
import AppKit

extension NSImage {

    // MARK: - Properties

    /// A data object that contains the specified image. For `NSImage`, the data is in TIFF format.
    var dataRepresentation: Data? { tiffRepresentation }

    // MARK: - Initialization

    /// Creates an image object that contains a system symbol image.
    /// - Parameter systemName: The name of the system symbol image.
    convenience init?(systemName name: String) {
        self.init(systemSymbolName: name, accessibilityDescription: nil)
    }

}

// MARK: - Sendable

extension NSImage: @unchecked Sendable { }
#endif
