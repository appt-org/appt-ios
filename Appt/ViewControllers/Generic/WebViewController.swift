//
//  WebViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/09/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import WebKit
import Accessibility

class WebViewController: ViewController {
 
    lazy var webView: WKWebView = {
        let userContentController = WKUserContentController()
                
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: view.frame, configuration: configuration)
        webView.scrollView.maximumZoomScale = 10.0
        webView.tintColor = .primary
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primary
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: .valueChanged)
        webView.scrollView.addSubview(refreshControl)
    }
    
    @objc func refreshWebView(_ sender: UIRefreshControl) {
        webView.reload()
        sender.endRefreshing()
    }

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

    func load(_ url: URL) {
        isLoading = true
        
        let request = URLRequest(url: url)
        webView.load(request)
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
            webView.constraint()
            view.sendSubviewToBack(webView)
            
            onLoaded()
        }
    }
            
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        
        if navigationAction.navigationType == .linkActivated {
            openWebsite(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
