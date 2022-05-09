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
    
    override func onLoaded() {
        print("onLoaded")
        
        // Add sticky header
        let javascript = """
            function addStickyHeader() {
                document.getElementsByTagName('header')[0].classList.add('sticky', 'top-0', 'z-50');
            }
        
            addStickyHeader();
        
            let previousUrl = '';
            const observer = new MutationObserver(function(mutations) {
              if (location.href !== previousUrl) {
                  previousUrl = location.href;
                  setTimeout(function() { addStickyHeader(); }, 100);
                }
            });
            const config = {subtree: true, childList: true};
            observer.observe(document, config);
        """

        webView.evaluateJavaScript(javascript, completionHandler: nil)
    }
}
