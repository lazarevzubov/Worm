//
//  ImageService.swift
//  Worm
//
//  Created by Nikita Lazarev-Zubov on 21.2.2021.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Retrieves images.
protocol ImageService: Sendable {

    // MARK: - Methods

    /// Retrieves the image from an URL.
    /// - Parameter url: The image URL.
    /// - Returns: The retrieved image.
#if os(iOS)
    func getImage(from url: URL) async -> UIImage?
#elseif os(macOS)
    func getImage(from url: URL) async -> NSImage?
#endif

}

// MARK: -

/// Coordinates a group of web service tasks.
protocol WebService: Sendable {

    // MARK: - Methods

    /// Retrieves the contents of the specified URL.
    /// - Parameter url: The URL the data is to be retrieved from.
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

#if os(iOS)
    func getImage(from url: URL) async -> UIImage? {
        if let (data, _) = try? await webService.data(from: url) {
            UIImage(data: data)
        } else {
            nil
        }
    }
#elseif os(macOS)
    func getImage(from url: URL) async -> NSImage? {
        if let (data, _) = try? await webService.data(from: url) {
            NSImage(data: data)
        } else {
            nil
        }
    }
#endif

}
