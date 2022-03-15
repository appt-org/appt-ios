//
//  _UIStoryboard.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
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
    
    private static func article(type: ArticleType) -> ArticleViewController {
        let articleViewController = viewController(.main, identifier: ArticleViewController.self)
        articleViewController.type = type
        return articleViewController
    }
    
    static func article(type: ArticleType, id: Int) -> ArticleViewController {
        let articleViewController = article(type: type)
        articleViewController.id = id
        return articleViewController
    }
    
    static func article(type: ArticleType, slug: String) -> ArticleViewController {
        let articleViewController = article(type: type)
        articleViewController.slug = slug
        return articleViewController
    }
    
    static func article(type: ArticleType, url: URL) -> ArticleViewController {
        let articleViewController = article(type: type)
        articleViewController.url = url
        return articleViewController
    }
    
    static func voiceOverGestures() -> VoiceOverGesturesViewController {
        return viewController(.voiceOver, identifier: VoiceOverGesturesViewController.self)
    }
    
    static func voiceOverGesture(gesture: Gesture) -> VoiceOverGestureViewController {
        let vc = viewController(.voiceOver, identifier: VoiceOverGestureViewController.self)
        vc.gesture = gesture
        return vc
    }
    
    static func voiceOverGesture(gestures: [Gesture], instructions: Bool = true) -> VoiceOverGestureViewController {
        let vc = viewController(.voiceOver, identifier: VoiceOverGestureViewController.self)
        vc.gesture = gestures[0]
        vc.gestures = gestures
        vc.instructions = instructions
        return vc
    }
    
    static func main(isNewUser: Bool = false) -> UIViewController? {
        let storyboard = UIStoryboard(name: Name.main.rawValue, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        (vc as? TabBarController)?.shouldShowEmailVerificationAlert = isNewUser
        return vc
    }
    
    static func training() -> TrainingViewController {
        let vc = viewController(.main, identifier: TrainingViewController.self)
        
        return vc
    }
    
    static func home(subject: Subject) -> HomeViewController {
        let vc = viewController(.main, identifier: HomeViewController.self)
        vc.subject = subject
        return vc
    }
    
    static func knowledgeBase(subject: Subject) -> KnowledgeViewController {
        let vc = viewController(.main, identifier: KnowledgeViewController.self)
        vc.subject = subject
        return vc
    }
    
    static func services(subject: Subject) -> ServicesViewController {
        let vc = viewController(.main, identifier: ServicesViewController.self)
        vc.subject = subject
        return vc
    }
    
    static func more(subject: Subject) -> MoreViewController {
        let vc = viewController(.main, identifier: MoreViewController.self)
        vc.subject = subject
        return vc
    }
}
