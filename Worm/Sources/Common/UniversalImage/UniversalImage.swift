//
//  UniversalImage.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 28.7.2024.
//

#if os(iOS)
import UIKit

/// A high-level interface for manipulating image data.
typealias UniversalImage = UIImage
#elseif os(macOS)
import AppKit

/// A high-level interface for manipulating image data.
typealias UniversalImage = NSImage
#endif
