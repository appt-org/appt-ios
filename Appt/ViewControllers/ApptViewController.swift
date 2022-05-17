//
//  ApptViewController.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 04/05/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit
import WebKit

class ApptViewController: ViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var toolbar: UIToolbar!
    
    @IBOutlet private var backItem: UIBarButtonItem!
    @IBOutlet private var forwardItem: UIBarButtonItem!
    @IBOutlet private var shareItem: UIBarButtonItem!
    @IBOutlet private var settingsItem: UIBarButtonItem!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primary
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Appt"
        
        webView.scrollView.maximumZoomScale = 10.0
        webView.tintColor = .primary
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.scrollView.refreshControl = refreshControl
        
        load("https://appt-dev-o4ale4roda-ez.a.run.app/en")
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        webView.reload()
    }
    
    
    private func load(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        load(url)
    }
    
    private func load(_ url: URL) {
        isLoading = true
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func onLoaded() {
        // Can be overridden
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

// MARK: - WKNavigationDelegate

extension ApptViewController: WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", webView.estimatedProgress == 1.0 {
            isLoading = false
            refreshControl.endRefreshing()
            
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
