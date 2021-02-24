//
//  AppDelegate.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Crashlytics
        FirebaseApp.configure()
        Events.property(.voiceover, value: UIAccessibility.isVoiceOverRunning)
        
        // Global tint & language
        window?.tintColor = .primary
        application.accessibilityLanguage = "language".localized
                
        // States
        let states: [UIControl.State] = [.disabled, .focused, .highlighted, .normal, .selected]
        
        // UINavigationBar styles
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .primary
        UINavigationBar.appearance().backgroundColor = .primary
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.sourceSansPro(weight: .bold, size: 18, style: .title1),
            .foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont.sourceSansPro(weight: .bold, size: 27, style: .title1),
            .foregroundColor: UIColor.white
        ]
        
        // UIBarButtonItem style
        UIBarButtonItem.appearance().tintColor = .white
        states.forEach { (state) in
            UIBarButtonItem.appearance().setTitleTextAttributes([
                .font: UIFont.sourceSansPro(weight: .semibold, size: 16, style: .title1)
            ], for: state)
        }
        
        // UITabBar styles
        UITabBar.appearance().barTintColor = .background
        UITabBar.appearance().tintColor = .primary
        UITabBar.appearance().unselectedItemTintColor = .disabled
        
        // UITabBarItem style
        states.forEach { (state) in
            UITabBarItem.appearance().setTitleTextAttributes([
                .font: UIFont.sourceSansPro(weight: .semibold, size: 14, style: .title1)
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
