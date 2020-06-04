//
//  _UIStoryboard.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    private static func initialViewController(_ storyboard: String) -> UIViewController? {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateInitialViewController()
    }
    
    private static func viewController(_ storyboard: String, identifier: String) -> UIViewController? {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    static func article(id: Int) -> ArticleViewController {
        let articleViewController = viewController("Main", identifier: "ArticleViewController") as! ArticleViewController
        articleViewController.id = id
        return articleViewController
    }
    
    static func article(slug: String) -> ArticleViewController {
        let articleViewController = viewController("Main", identifier: "ArticleViewController") as! ArticleViewController
        articleViewController.slug = slug
        return articleViewController
    }
}
