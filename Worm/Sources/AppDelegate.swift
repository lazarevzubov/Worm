//
//  AppDelegate.swift
//  Worm
//
//  Created by Lazarev-Zubov, Nikita on 17.5.2024.
//

import GoogleMobileAds

// Required for starting GADMobileAds.
/// Manages shared legacy behaviors of the app.
final class AppDelegate: NSObject, UIApplicationDelegate {

    // MARK: - Methods

    // MARK: UIApplicationDelegate protocol methods

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
#if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["9bbdd8d5a0d3643c7f2d9cb90bba5f48"]
#endif

        return true
    }

}
