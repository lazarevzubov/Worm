//
//  Bundle.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 28.7.2024.
//

#if os(iOS)
import UIKit

extension Bundle {

    // MARK: - Methods

    /// Returns an `UIImage` instance associated with the specified name, which can be backed by multiple files representing different resolution versions of the
    ///   image.
    /// - Parameter name: The filename of the image resource file. Including a filename extension is optional.
    /// - Returns: The `UIImage` object associated with the specified name, or `nil` if no file is found.
    func image(forResource name: String) -> UIImage? {
        UIImage(named: name, in: self, compatibleWith: nil)
    }

}
#endif
