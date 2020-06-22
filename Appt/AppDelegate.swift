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
        
        // States
        let states: [UIControl.State] = [.disabled, .focused, .highlighted, .normal, .selected]
        
        // UINavigationBar styles
        UINavigationBar.appearance().tintColor = .primary
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.sourceSansPro(weight: .bold, size: 20),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        
        // UIBarButtonItem style
        UIBarButtonItem.appearance().tintColor = .primary
        states.forEach { (state) in
            UIBarButtonItem.appearance().setTitleTextAttributes([
                .font: UIFont.sourceSansPro(weight: .semibold, size: 18)
            ], for: state)
        }
        
        // UISegmentedControl styles
        UISegmentedControl.appearance().tintColor = .primary
        states.forEach { (state) in
            UISegmentedControl.appearance().setTitleTextAttributes([
                .font: UIFont.sourceSansPro(weight: .bold, size: 20),
                .foregroundColor: UIColor.black25
            ], for: state)
        }
        UISegmentedControl.appearance().setTitleTextAttributes([
            .font: UIFont.sourceSansPro(weight: .bold, size: 20),
            .foregroundColor: UIColor.primary
        ], for: .selected)
        
        // UITabBar styles
        UITabBar.appearance().tintColor = .primary
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .black25
        
        // UITabBarItem style
        states.forEach { (state) in
            UITabBarItem.appearance().setTitleTextAttributes([
                .font: UIFont.sourceSansPro(weight: .semibold, size: 18)
            ], for: state)
        }
        
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
