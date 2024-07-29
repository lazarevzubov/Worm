//
//  UIImage.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 28.7.2024.
//

#if os(iOS)
import UIKit

extension UIImage {

    // MARK: - Properties

    /// A data object that contains the specified image. For `UIImage`, the data is in PNG format.
    var dataRepresentation: Data? { pngData() }

}
#endif
