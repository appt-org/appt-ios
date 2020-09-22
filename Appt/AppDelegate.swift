//
//  AppDelegate.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.tintColor = .primary
        application.accessibilityLanguage = "nl"
        
        // States
        let states: [UIControl.State] = [.disabled, .focused, .highlighted, .normal, .selected]
        
        // UINavigationBar styles
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .background
        UINavigationBar.appearance().tintColor = .primary
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.sourceSansPro(weight: .bold, size: 20, style: .headline)
        ]
        
        // UIBarButtonItem style
        UIBarButtonItem.appearance().tintColor = .primary
        states.forEach { (state) in
            UIBarButtonItem.appearance().setTitleTextAttributes([
                .font: UIFont.sourceSansPro(weight: .semibold, size: 18, style: .title2)
            ], for: state)
        }
        
        // UITabBar styles
        UITabBar.appearance().barTintColor = .background
        UITabBar.appearance().tintColor = .primary
        states.forEach { (state) in
            UITabBarItem.appearance().setTitleTextAttributes([
                .font: UIFont.sourceSansPro(weight: .semibold, size: 18, style: .title2)
            ], for: state)
        }
        
        // UISegmentedControl styles
        UISegmentedControl.appearance().tintColor = .primary
        states.forEach { (state) in
            UISegmentedControl.appearance().setTitleTextAttributes([
                .font: UIFont.sourceSansPro(weight: .bold, size: 18, style: .body)
            ], for: state)
        }
        UISegmentedControl.appearance().setTitleTextAttributes([
            .font: UIFont.sourceSansPro(weight: .bold, size: 18, style: .body),
            .foregroundColor: UIColor.primary
        ], for: .selected)
        
        return true
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
}
