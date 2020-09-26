//
//  _UIStoryboard.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum Name: String{
        case main = "Main"
        case voiceOver = "VoiceOver"
    }
    
    private static func viewController<T: UIViewController>(_ storyboard: UIStoryboard.Name, identifier : T.Type? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        if let identifier = identifier {
            return storyboard.instantiateViewController(withIdentifier: String(describing: identifier)) as! T
        } else {
            return storyboard.instantiateInitialViewController() as! T
        }
    }
    
    static func article(type: ArticleType, id: Int) -> ArticleViewController {
        let articleViewController = viewController(.main, identifier: ArticleViewController.self)
        articleViewController.type = type
        articleViewController.id = id
        return articleViewController
    }
    
    static func article(type: ArticleType, slug: String) -> ArticleViewController {
        let articleViewController = viewController(.main, identifier: ArticleViewController.self)
        articleViewController.type = type
        articleViewController.slug = slug
        return articleViewController
    }
    
    static func voiceOverGestures() -> VoiceOverGesturesViewController {
        return viewController(.voiceOver, identifier: VoiceOverGesturesViewController.self)
    }
    
    static func voiceOverGesture(gesture: Gesture, gestures: [Gesture]?) -> VoiceOverGestureViewController {
        let vc = viewController(.voiceOver, identifier: VoiceOverGestureViewController.self)
        vc.gesture = gesture
        vc.gestures = gestures
        return vc
    }
}
