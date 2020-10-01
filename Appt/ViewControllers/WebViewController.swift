//
//  WebViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import WebKit
import Accessibility

class WebViewController: ViewController {
 
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: view.frame, configuration: configuration)
        webView.scrollView.maximumZoomScale = 10.0
        webView.tintColor = .primary
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        return webView
    }()

    func load(_ content: String, title: String) {
        Events.log(.article, identifier: title)
        
        let html = """
                <html lang="nl">
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1"/>
                        <link rel="stylesheet" type="text/css" href="style.css">
                    </head>
                <body>
                <h1>
                """ + title + """
                </h1>
                """ + content + """
                </body>
                </html>
        """

        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
    func onLoaded() {
        // Can be overridden
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", webView.estimatedProgress == 1.0 {
            isLoading = false
            
            view.addSubview(webView)
            webView.constraintToSafeArea()
            view.bringSubviewToFront(webView)
            
            onLoaded()
        }
    }
            
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        
        if navigationAction.navigationType == .linkActivated {
            if url.absoluteString.contains("appt.nl/kennisbank/") {
                let articleViewController = UIStoryboard.article(type: .post, slug: url.lastPathComponent)
                navigationController?.pushViewController(articleViewController, animated: true)
            } else {
                openWebsite(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
