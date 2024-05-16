//
//  BannerViewController.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 17.5.2024.
//

import UIKit

/// The view controller for a banner.
final class BannerViewController: UIViewController {

    // MARK: - Properties

    /// Handles width update messages.
    weak var delegate: BannerViewControllerWidthDelegate?

    // MARK: - Methods

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.bannerViewController(self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in
            // Do nothing.
        } completion: { [weak self] _ in
            guard let self else {
                return
            }
            self.delegate?.bannerViewController(
                self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width
            )
        }
    }

}
