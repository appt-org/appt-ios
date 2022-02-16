//
//  AppDelegate.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import SDWebImage
import SDWebImageSVGKitPlugin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISceneDelegate {

    var window: UIWindow?

    private var deepLinkManager = DeepLinkManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Crashlytics
        FirebaseApp.configure()
        Events.property(.voiceover, value: UIAccessibility.isVoiceOverRunning)

        if #available(iOS 13.0, *) {} else {
            self.configureWindow()
        }

        // Global tint & language
        window?.tintColor = .primary
        application.accessibilityLanguage = "language".localized
                
        // States
        let states: [UIControl.State] = [.disabled, .focused, .highlighted, .normal, .selected]
        
        // UINavigationBar styles
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .background
        UINavigationBar.appearance().backgroundColor = .background
        UINavigationBar.appearance().tintColor = .foreground
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.openSans(weight: .bold, size: 18, scaled: false),
            .foregroundColor: UIColor.foreground
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont.openSans(weight: .bold, size: 27, scaled: false),
            .foregroundColor: UIColor.foreground
        ]
        
        // UIBarButtonItem style
        UIBarButtonItem.appearance().tintColor = .foreground
        states.forEach { (state) in
            UIBarButtonItem.appearance().setTitleTextAttributes([
                .font: UIFont.openSans(weight: .regular, size: 16, scaled: false)
            ], for: state)
        }
        
        // UITabBar styles
        UITabBar.appearance().barTintColor = .background
        UITabBar.appearance().tintColor = .primary
        UITabBar.appearance().unselectedItemTintColor = .disabled
        
        // UITabBarItem style
        states.forEach { (state) in
            UITabBarItem.appearance().setTitleTextAttributes([
                .font: UIFont.openSans(weight: .bold, size: 12, scaled: false)
            ], for: state)
        }
        
        // UISegmentedControl styles
        UISegmentedControl.appearance().backgroundColor = .background
        UISegmentedControl.appearance().tintColor = .primary
        states.forEach { (state) in
            UISegmentedControl.appearance().setTitleTextAttributes([
                .font: UIFont.openSans(weight: .regular, size: 18, scaled: false)
            ], for: state)
        }
        UISegmentedControl.appearance().setTitleTextAttributes([
            .font: UIFont.openSans(weight: .bold, size: 18, scaled: false),
            .foregroundColor: UIColor.white
        ], for: .selected)

        // IQKeyboardManager
        IQKeyboardManager.shared.enable = true

        let svgCoder = SDImageSVGKCoder.shared
        SDImageCodersManager.shared.addCoder(svgCoder)
        
        return true
    }

    private func configureWindow() {
        let viewController = UIStoryboard.main()

        let window = UIWindow()
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }


    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        self.deepLinkManager.handleDeepLink(url: userActivity.webpageURL)

        return true
    }

}
