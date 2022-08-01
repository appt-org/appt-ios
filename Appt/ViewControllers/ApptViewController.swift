//
//  ApptViewController.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 04/05/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit
import WebKit
import Rswift

class ApptViewController: ViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var toolbar: UIToolbar!
    
    @IBOutlet private var backItem: UIBarButtonItem!
    @IBOutlet private var forwardItem: UIBarButtonItem!
    @IBOutlet private var shareItem: UIBarButtonItem!
    @IBOutlet private var bookmarkItem: UIBarButtonItem!
    @IBOutlet private var menuItem: UIBarButtonItem!
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primary
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.appt_title()
        
        webView.scrollView.maximumZoomScale = 10.0
        webView.tintColor = .primary
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.scrollView.refreshControl = refreshControl
        
        backItem.title = R.string.localizable.back()
        backItem.accessibilityLabel = R.string.localizable.back()
        
        forwardItem.title = R.string.localizable.forward()
        forwardItem.accessibilityLabel = forwardItem.title
        
        shareItem.title = R.string.localizable.share()
        shareItem.accessibilityLabel = shareItem.title
        
        bookmarkItem.title = R.string.localizable.bookmark()
        bookmarkItem.accessibilityLabel = bookmarkItem.title
        
        menuItem.title = R.string.localizable.menu()
        menuItem.accessibilityLabel = menuItem.title
        
        let url = Preferences.shared.url ?? R.string.localizable.appt_url()
        load(url)
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
    
    // MARK: - Toolbar actions
    
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
    
    private var bookmarks = [String: Bool]()
    
    @IBAction private func onBookmark(_ sender: Any) {
        guard let url = webView.url?.absoluteString else {
            return
        }
        
        let bookmarked = !(bookmarks[url] ?? false)
        bookmarks[url] = bookmarked
        
        updateBookmark(bookmarked)
    }
    
    private func updateBookmark(_ url: String) {
        let bookmarked = bookmarks[url] ?? false
        updateBookmark(bookmarked)
    }
    
    private func updateBookmark(_ bookmarked: Bool) {
        let icon = bookmarked ? R.image.icon_bookmarked() : R.image.icon_bookmark()
        let text = bookmarked ? R.string.localizable.bookmarked() : R.string.localizable.bookmark()
        
        bookmarkItem.image = icon
        bookmarkItem.title = text
        bookmarkItem.accessibilityLabel = text
    }
    
    @IBAction private func onMenu(_ sender: Any) {
        let vc = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let homeAction = UIAlertAction(title: R.string.localizable.home(), style: .default) { action in
            let homeUrl = R.string.localizable.appt_url()
            self.load(homeUrl)
        }
        vc.addAction(homeAction)
                
        let bookmarksAction = UIAlertAction(title: R.string.localizable.bookmarks(), style: .default) { action in
            // Ignored
        }
        vc.addAction(bookmarksAction)
        
        let historyAction = UIAlertAction(title: R.string.localizable.history(), style: .default) { action in
            // Ignored
        }
        vc.addAction(historyAction)
        
        let settingsAction = UIAlertAction(title: R.string.localizable.settings(), style: .default) { action in
            // Ignored
        }
        vc.addAction(settingsAction)
        
        let refreshAction = UIAlertAction(title: R.string.localizable.reload(), style: .default) { action in
            UIAccessibility.post(notification: .announcement, argument: R.string.localizable.loading())
            self.webView.reload()
        }
        
        vc.addAction(refreshAction)
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        vc.addAction(cancelAction)
        
        present(vc, animated: true)
    }
    
    // MARK : - WebView changes
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else {
            return
        }
        
        switch keyPath {
        case #keyPath(WKWebView.estimatedProgress):
            onEstimatedProgressChanged()
        case #keyPath(WKWebView.url):
            onUrlChanged()
        default:
            print("Missing handler for keyPath \(keyPath)")
        }
    }
        
    private func onUrlChanged() {
        print("onUrlChanged")
        
        backItem.isEnabled = webView.canGoBack
        forwardItem.isEnabled = webView.canGoForward
        
        if let url = webView.url?.absoluteString {
            shareItem.isEnabled = true
            
            bookmarkItem.isEnabled = true
            updateBookmark(url)
            
            Preferences.shared.url = url
        }
    }
    
    private func onEstimatedProgressChanged() {
        print("onEstimatedProgressChanged")
        
        if webView.estimatedProgress == 1.0 {
            isLoading = false
            refreshControl.endRefreshing()
            
            onLoaded()
            onUrlChanged()
        }
    }
}

// MARK: - WKNavigationDelegate

extension ApptViewController: WKNavigationDelegate {
                
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
                
        if navigationAction.navigationType != .linkActivated {
            decisionHandler(.allow)
            return
        }
        
        if url.host == R.string.localizable.appt_domain() {
            print("Action on own domain")
            decisionHandler(.allow)
            return
        }
        
        openWebsite(url)
        decisionHandler(.cancel)
    }
}
