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
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }

    func openWebsite(_ urlString: String, delegate: SFSafariViewControllerDelegate? = nil) {
        guard let url = URL(string: urlString) else {
            return
        }
        openWebsite(url)
    }
    
    func openWebsite(_ url: URL, delegate: SFSafariViewControllerDelegate? = nil) {
        guard url.absoluteString.starts(with: "http") else {
            if url.absoluteString.starts(with: "mailto") {
                // TODO: Show list of e-mail clients
            }
            UIApplication.shared.open(url)
            return
        }
        
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false
        configuration.entersReaderIfAvailable = false
        
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        safariViewController.delegate = delegate
        safariViewController.preferredBarTintColor = .background
        safariViewController.preferredControlTintColor = .primary
        safariViewController.modalPresentationCapturesStatusBarAppearance = true
        safariViewController.modalPresentationStyle = .pageSheet
        safariViewController.dismissButtonStyle = .close
        
        present(safariViewController, animated: true)
    }
}
