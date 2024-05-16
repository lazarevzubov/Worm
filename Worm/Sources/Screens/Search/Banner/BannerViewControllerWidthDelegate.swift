//
//  BannerViewControllerWidthDelegate.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 17.5.2024.
//

import CoreGraphics

/// Delegate methods for receiving width update messages.
protocol BannerViewControllerWidthDelegate: AnyObject {

    // MARK: - Methods

    /// Called when the banner area width changes.
    /// - Parameters:
    ///   - bannerViewController: The banner view controller.
    ///   - width: The new width value.
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)

}
