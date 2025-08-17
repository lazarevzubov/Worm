//
//  ImageMockService.swift
//  WormTests
//
//  Created by Lazarev-Zubov, Nikita on 5.4.2024.
//

import CoreGraphics
import Foundation
@testable
import Worm

struct ImageMockService: ImageService {

    // MARK: - Properties

    let images: [URL : CGImage]

    // MARK: - Initialization

    init(images: [URL : CGImage] = [:]) {
        self.images = images
    }

    // MARK: - Methods

    // MARK: ImageService protocol methods

    func getImage(from url: URL) async -> CGImage? {
        images[url]
    }

}
