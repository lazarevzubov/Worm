//
//  Image.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 14.7.2024.
//

#if os(iOS)
import UIKit

typealias Image = UIImage
#elseif os(macOS)
import AppKit

typealias Image = NSImage
#endif
