//
//  _UIViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 04/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func openWebsite(_ urlString: String, delegate: SFSafariViewControllerDelegate? = nil) {
        if let url = URL(string: urlString) {
            openWebsite(url, delegate: delegate)
        }
    }
    
    func openWebsite(_ url: URL, delegate: SFSafariViewControllerDelegate? = nil) {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false
        configuration.entersReaderIfAvailable = false
        
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        safariViewController.delegate = delegate
        safariViewController.preferredBarTintColor = .background
        safariViewController.preferredControlTintColor = .foreground
        safariViewController.dismissButtonStyle = .done
        
        present(safariViewController, animated: true)
    }
}

extension UIViewController {
    func performSegue(_ identifier: UIStoryboardSegue.Identifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
}


extension ViewController {
    func animateWithKeyboard(
        notification: NSNotification,
        animations: ((_ keyboardFrame: CGRect) -> Void)?
    ) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        let duration = notification.userInfo![durationKey] as! Double

        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue

        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        let curveValue = notification.userInfo![curveKey] as! Int
        let curve = UIView.AnimationCurve(rawValue: curveValue)!

        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve
        ) {
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)

            // Required to trigger NSLayoutConstraint changes
            // to animate
            self.view?.layoutIfNeeded()
        }

        // Start the animation
        animator.startAnimation()
    }
}
