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



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // UINavigationBar styles
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.sourceSansPro(weight: .bold, size: 20),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .primary
        
        // UIBarButtonItem style
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.sourceSansPro(weight: .semibold, size: 18)
        ], for: .normal)
        
        // UISegmentedControl styles
        UISegmentedControl.appearance().tintColor = .primary
        UISegmentedControl.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.sourceSansPro(weight: .bold, size: 20),
            NSAttributedString.Key.foregroundColor: UIColor.black25
        ], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.sourceSansPro(weight: .bold, size: 20),
            NSAttributedString.Key.foregroundColor: UIColor.primary
        ], for: .selected)
        
        // UITabBar styles
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = .primary
        UITabBar.appearance().unselectedItemTintColor = .black25
        
        // UITabBarItem style
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.sourceSansPro(weight: .semibold, size: 18)
        ], for: .normal)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

