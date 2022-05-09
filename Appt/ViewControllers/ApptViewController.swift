//
//  ApptViewController.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 04/05/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit

class ApptViewController: WebViewController {
    
    @IBOutlet private var toolbar: UIToolbar!
    
    @IBOutlet private var backItem: UIBarButtonItem!
    @IBOutlet private var forwardItem: UIBarButtonItem!
    @IBOutlet private var shareItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appt"
        
        guard let url = URL(string: "https://appt-dev-o4ale4roda-ez.a.run.app") else {
            return
        }
        load(url)
    }
    
    @IBAction private func onBack(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction private func onForward(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @IBAction private func onShare(_ sender: Any) {
        guard let url = webView.url else {
            return
        }
        
        let shareViewController = UIActivityViewController(activityItems: [url], applicationActivities: [])
        shareViewController.popoverPresentationController?.barButtonItem = shareItem
        present(shareViewController, animated: true)
    }
}
