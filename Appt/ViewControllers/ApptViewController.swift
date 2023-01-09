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
import CoreData

class ApptViewController: ViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var toolbar: UIToolbar!
    
    @IBOutlet private var backItem: ToolbarItem!
    @IBOutlet private var forwardItem: ToolbarItem!
    @IBOutlet private var shareItem: ToolbarItem!
    @IBOutlet private var bookmarkItem: ToolbarItem!
    @IBOutlet private var moreItem: ToolbarItem!
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primary
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var stack: CoreDataStack = {
        return CoreDataStack()
    }()
    var pages: [NSManagedObject] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.appt_title()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.scrollView.minimumZoomScale = 0.25
        webView.scrollView.maximumZoomScale = 10.0
        webView.zoomScale = Preferences.shared.zoomScale
        webView.tintColor = .primary
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        webView.scrollView.refreshControl = refreshControl
        
        backItem.item = .back
        backItem.onTap = { item in
            self.goBack()
        }
        backItem.onLongPress = { item in
            self.showHistoryBack()
        }        
        
        forwardItem.item = .forward
        forwardItem.onTap = { item in
            self.goForward()
        }
        forwardItem.onLongPress = { item in
            self.showHistoryForward()
        }
        
        shareItem.item = .share
        shareItem.onTap = { item in
            self.onShare()
        }
        
        bookmarkItem.item = .bookmarked
        bookmarkItem.onTap = { item in
            self.onBookmark()
        }
        bookmarkItem.onLongPress = { item in
            self.showBookmarks()
        }

        if #available(iOS 15.0, *) {
            var items: [Item] = [.home, .reload, .bookmarks, .history, .settings]
            items.reverse()
            
            var actions = [UIAction]()
            for item in items {
                let action = UIAction(
                    title: item.title,
                    subtitle: nil,
                    image: item.image,
                    discoverabilityTitle: nil,
                    attributes: []
                ) { action in
                    print("More item '\(item.title)' clicked")
                    
                    switch item {
                        case .home: self.home()
                        case .reload: self.reload()
                        case .bookmarks: self.showBookmarks()
                        case .history: self.showHistory()
                        case .settings: self.showSettings()
                        default: print("Missing action for more item '\(item)'")
                    }
                }
                actions.append(action)
            }
            
            moreItem.menu = UIMenu(
                title: "",
                subtitle: nil,
                image: nil,
                identifier: nil,
                options: .destructive,
                children: actions
            )
            moreItem.image = Item.more.image
        } else {
            moreItem.item = .more
            moreItem.onTap = { item in
                self.showMore()
            }
        }
        
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
    
    private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    private func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    private func onShare() {
        guard let url = webView.url else {
            return
        }
        
        let shareViewController = UIActivityViewController(activityItems: [url], applicationActivities: [])
        shareViewController.popoverPresentationController?.barButtonItem = shareItem
        present(shareViewController, animated: true)
    }
    
    private func onBookmark() {
        guard let url = webView.url?.absoluteString else {
            return
        }
        
        var bookmarked = false
        
        // Insert or delete bookmark
        do {
            if let bookmark = try stack.fetch(Bookmark.createFetchRequest(), url: url) {
                // Remove bookmark
                stack.context.delete(bookmark)
            } else {
                // Insert bookmark
                let bookmark = Bookmark(context: stack.context)
                bookmark.url = url
                bookmark.title = webView.title
                bookmark.createdAt = Date()
                bookmark.updatedAt = Date()
                
                bookmarked = true
            }
            
            try stack.context.save()
        } catch let error as NSError {
            print("Failed to save bookmark: \(error) --> \(error.userInfo)")
        }
        
        updateBookmark(bookmarked)
    }
    
    private func updateBookmark(_ url: String) {
        var bookmarked = false
        
        // Get bookmark state
        do {
            if let _ = try stack.fetch(Bookmark.createFetchRequest(), url: url) {
                bookmarked = true
            }
        } catch let error as NSError {
            print("Failed to fetch bookmark: \(error) --> \(error.userInfo)")
        }
        
        updateBookmark(bookmarked)
    }
    
    private func updateBookmark(_ bookmarked: Bool) {
        if bookmarked {
            bookmarkItem.item = .bookmarked
        } else {
            bookmarkItem.item = .bookmark
        }
    }
    
    private func showMore() {
        let vc = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        vc.popoverPresentationController?.barButtonItem = moreItem
        
        vc.addItem(.home) { action in
            self.home()
        }
        
        vc.addItem(.reload) { action in
            self.reload()
        }

        vc.addItem(.bookmarks) { action in
            self.showBookmarks()
        }

        vc.addItem(.history) { action in
            self.showHistory()
        }
        
        vc.addItem(.settings) { action in
            self.showSettings()
        }
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        vc.addAction(cancelAction)
        
        present(vc, animated: true)
    }
    
    private func home() {
        let homeUrl = R.string.localizable.appt_url()
        self.load(homeUrl)
    }
    
    private func reload() {
        UIAccessibility.post(notification: .announcement, argument: R.string.localizable.loading())
        webView.reload()
    }
    
    private func showHistory() {
        showPages(.history)
    }
    
    private func showBookmarks() {
        showPages(.bookmarks)
    }

    @objc private func showHistoryBack() {
        guard webView.canGoBack else {
            self.showError("Cannot go back")
            return
        }
        showItems(.jumpBack, items: webView.backForwardList.backList.reversed())
    }
    
    private func showHistoryForward() {
        guard webView.canGoForward else {
            self.showError("Cannot go forward")
            return
        }
        showItems(.jumpForward, items: webView.backForwardList.forwardList)
    }
    
    private func showItems(_ item: Item, items: [WKBackForwardListItem]) {
        let pages = items.map { item in
            return WebViewPage(url: item.url.absoluteString, title: item.title)
        }
        showPages(item, pages: pages)
    }
    
    private func showPages(_ item: Item, pages: [Page] = [Page]()) {
        guard let navigationViewController = R.storyboard.main.pagesNavigationViewController(),
              let pagesViewController = navigationViewController.topViewController as? PagesViewController else {
            return
        }
        pagesViewController.delegate = self
        pagesViewController.stack = self.stack
        pagesViewController.item = item
        pagesViewController.pages = pages
        
        present(navigationViewController, animated: true)
    }
    
    private func showSettings() {
        guard let navigationViewController = R.storyboard.main.settingsNavigationViewController(),
              let settingsViewController = navigationViewController.topViewController as? SettingsViewController else {
            return
        }
                
        settingsViewController.delegate = self
        
        present(navigationViewController, animated: true)
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
        case #keyPath(WKWebView.title):
            onTitleChanged()
        default:
            print("Missing handler for keyPath \(keyPath)")
        }
    }
        
    private func onUrlChanged() {
        print("onUrlChanged")
        
        backItem.isEnabled = webView.canGoBack
        forwardItem.isEnabled = webView.canGoForward
        
        guard let url = webView.url?.absoluteString else {
            return
        }
        
        shareItem.isEnabled = true
        
        bookmarkItem.isEnabled = true
        updateBookmark(url)
        
        Preferences.shared.url = url
        Events.log(.url, identifier: url)
    }
    
    private func onTitleChanged() {
        guard let title = webView.title,
              let url = webView.url?.absoluteString else {
            return
        }
                
        print("Title changed to: '\(title)' for url: \(url)")
        
        // Store visited page
        let page = History(context: stack.context)
        page.url = url
        page.title = title
        page.createdAt = Date()
        page.updatedAt = Date()
                
        do {
            try stack.context.save()
        } catch let error as NSError {
            print("Failed to save history: \(error) --> \(error.userInfo)")
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

// MARK: - Accessibility

extension ApptViewController {
 
    override func accessibilityPerformEscape() -> Bool {
        goBack()
        return true
    }
    
    override func accessibilityPerformMagicTap() -> Bool {
        onShare()
        return true
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard let code = (error as? NSError)?.code else {
            return
        }
        print("didFailProvisionalNavigation: \(code)")
        
        // Log error
        if let url = webView.url?.absoluteString {
            Events.log(.error, identifier: url, value: code)
        }
        
        // Show error based on error code
        let error = URLError.Code(rawValue: code)
        
        switch error {
        case .notConnectedToInternet:
            showError(R.string.localizable.error_network())
        default:
            showError(R.string.localizable.error_something())
            break
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let statusCode = (navigationResponse.response as? HTTPURLResponse)?.statusCode else {
            print("No response")
            decisionHandler(.allow)
            return
        }

        if statusCode == 200 || statusCode == 301 || statusCode == 302 {
            decisionHandler(.allow)
            return
        }

        // Show error based on status code
        if statusCode == 404 {
            showError(R.string.localizable.error_404())
        } else if statusCode >= 500 && statusCode <= 600 {
            showError(R.string.localizable.error_server())
        } else {
            print("Status code \(statusCode) is unhandled")
            showError(R.string.localizable.error_something())
        }

        decisionHandler(.allow)
    }
}

// MARK: - WKUIDelegate

extension ApptViewController: WKUIDelegate {
    
    private func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) {
        print("runJavaScriptAlertPanelWithMessage")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("runJavaScriptAlertPanelWithMessage")
        
        completionHandler()
    }
}

// MARK: - PagesViewControllerDelegate

extension ApptViewController: PagesViewControllerDelegate {
    
    func didSelectPage(_ page: Page) {
        load(page.url)
    }
}

// MARK: - SettingsViewControllerDelegate

extension ApptViewController: SettingsViewControllerDelegate {
    
    func onZoomChanged(_ scale: Double) {
        webView.zoomScale = scale
        Preferences.shared.zoomScale = scale
    }
}
