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
