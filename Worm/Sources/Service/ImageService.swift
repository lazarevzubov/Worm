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

    /**
     Retrieves the image from an URL.
     - Parameters:
        - url: The image URL.
        - resultCompletion: The block of code to run on result.
            - image: The retrieved image.
     */
    func getImage(for url: URL, resultCompletion: @escaping (_ image: UIImage?) -> Void)

}

// MARK: -

/// Represents a single web service task.
protocol WebServiceTask {

    // MARK: - Methods

    /// Starts the task.
    func resume()

}

// MARK: - WebServiceTask

extension URLSessionTask: WebServiceTask { }

// MARK: -

/// Coordinates a group of web service tasks.
protocol WebService {

    associatedtype Task: WebServiceTask

    // MARK: - Methods

    /**
     Creates a task that retrieves the contents of the specified URL, then calls a handler upon completion.

     - Parameters:
        - url: The URL to be retrieved.
        - completionHandler: The completion handler to call when the load request is complete.
        - data: The data returned by the server.
        - response: An object that provides response metadata, such as HTTP headers and status code.
        - error: An error object that indicates why the request failed, or `nil` if the request was successful.

     - Returns: The new session data task.
     */
    func dataTask(with url: URL,
                  completionHandler: @escaping (_ data: Data?,
                                                _ response: URLResponse?,
                                                _ error: Error?) -> Void) -> Task

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

    /**
     Creates the service,
     - Parameter webService: The web service for making network requests.
     */
    init(webService: DownloadService) {
        self.webService = webService
    }

    // MARK: - Methods

    // MARK: ImageService protocol methods

    func getImage(for url: URL, resultCompletion: @escaping (_ book: UIImage?) -> Void) {
        webService.dataTask(with: url) { data, _, _ in
            if let data = data {
                let image = UIImage(data: data)
                resultCompletion(image)
            } else {
                resultCompletion(nil)
            }
        }.resume()
    }

}
