//
//  BannerView.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 17.5.2024.
//

import AdSupport
import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI

/// The banner.
struct BannerView: UIViewControllerRepresentable {

    // MARK: - Properties

    @State
    fileprivate var viewWidth = CGFloat.zero

    // MARK: Private properties

    private static let adUnitID = "ca-app-pub-3940256099942544/2934735716"
    private let bannerView = GADBannerView()

    // MARK: - Methods

    // MARK: UIViewControllerRepresentable protocol methods

    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = BannerViewController()
        bannerViewController.delegate = context.coordinator

        bannerView.adUnitID = Self.adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)

        return bannerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else {
            return
        }

        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        let request = GADRequest()
        bannerView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // MARK: Private methods

    private func trackingIdentifier() -> UUID? {
        if trackingAccessAvailable() {
            return ASIdentifierManager.shared().advertisingIdentifier
        }
        return nil
    }

    private func trackingAccessAvailable() -> Bool {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized:
            true
        case .notDetermined,
             .restricted,
             .denied:
            false
        @unknown
        default:
            false
        }
    }

    // MARK: -

    final class Coordinator: NSObject, BannerViewControllerWidthDelegate {

        // MARK: - Properties

        // MARK: Private properties

        private let parent: BannerView

        // MARK: - Initialization

        init(parent: BannerView) {
            self.parent = parent
        }

        // MARK: - Methods

        // MARK: BannerViewControllerWidthDelegate protocol methods

        func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
            // Pass the viewWidth from Coordinator to BannerView.
            parent.viewWidth = width
        }
    }

}
