//
//  ViewEmbedder.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/14/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class ViewEmbedder {
    class func embed(parent: UIViewController, container: UIView, child: UIViewController, previous: UIViewController?) {
        if let previous = previous {
            removeFromParent(vc: previous)
        }
        child.willMove(toParent: parent)
        parent.addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: parent)

        let width = container.frame.size.width
        let height = container.frame.size.height
        child.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }

    class func removeFromParent(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    class func embed(withIdentifier id: String, parent: UIViewController, container: UIView, completion:((UIViewController) -> Void)? = nil) {
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(parent: parent, container: container, child: vc, previous: parent.children.first)
        completion?(vc)
    }
}
