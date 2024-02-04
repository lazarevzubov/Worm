//
//  ImageService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 21.2.2021.
//

import UIKit

/// Retrieves images.
protocol ImageService {

    // MARK: - Methods

    /// Retrieves the image from an URL.
    /// - Parameters:
    ///   - url: The image URL.
    ///   - resultCompletion: The block of code to run on result.
    ///     - image: The retrieved image.
    func getImage(from url: URL) async -> UIImage?

}

// MARK: -

/// Coordinates a group of web service tasks.
protocol WebService {

    // MARK: - Methods

    /// Retrieves the contents of the specified URL.
    /// - Parameters:
    ///   - url: The URL the data is to be retrieved from.
    /// - Returns: The data returned by the server and an object that provides response metadata, such as HTTP headers and status code.
    func data(from url: URL) async throws -> (Data, URLResponse)

}

// MARK: - WebServiceSession

extension URLSession: WebService { }

// MARK: -

/// The image retrieving service based on the web service.
final class ImageWebService<DownloadService: WebService>: ImageService {

    // MARK: - Properties

    // MARK: Private properties

    private let webService: DownloadService

    // MARK: - Initialization

    /// Creates the service.
    /// - Parameter webService: The web service for making network requests.
    init(webService: DownloadService) {
        self.webService = webService
    }

    // MARK: - Methods

    // MARK: ImageService protocol methods

    func getImage(from url: URL) async -> UIImage? {
        if let (data, _) = try? await webService.data(from: url) {
            UIImage(data: data)
        } else {
            nil
        }
    }

}
