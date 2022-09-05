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
    @IBOutlet private var menuItem: ToolbarItem!
    
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
        
        webView.scrollView.maximumZoomScale = 10.0
        webView.tintColor = .primary
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
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
                
        menuItem.item = .menu
        menuItem.onTap = { item in
            self.onMenu()
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
            let fetchRequest = BookmarkedPage.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: true)]
            fetchRequest.predicate = NSPredicate(format: "url LIKE %@", url)
            fetchRequest.fetchLimit = 1

            if let bookmark = try stack.objectContext.fetch(fetchRequest).first {
                // Remove bookmark
                stack.objectContext.delete(bookmark)
            } else {
                // Insert bookmark
                let bookmark = BookmarkedPage(context: stack.objectContext)
                bookmark.url = url
                bookmark.title = webView.title
                bookmark.created_at = Date()
                bookmark.updated_at = Date()
                
                bookmarked = true
            }
 
            try stack.objectContext.save()
        } catch let error as NSError {
            print("Failed to save bookmark: \(error) --> \(error.userInfo)")
        }
        
        updateBookmark(bookmarked)
    }
    
    private func updateBookmark(_ url: String) {
        var bookmarked = false
        
        // Get bookmark state
        do {
            let fetchRequest = BookmarkedPage.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: true)]
            fetchRequest.predicate = NSPredicate(format: "url LIKE %@", url)
            fetchRequest.fetchLimit = 1
            
            bookmarked = try stack.objectContext.fetch(fetchRequest).count > 0
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
    
    private func onMenu() {
        let vc = UIAlertController(
            title: R.string.localizable.menu(),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        vc.popoverPresentationController?.barButtonItem = menuItem
        
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
    
    private func showBookmarks() {
        do {
            let fetchRequest = BookmarkedPage.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
            let pages = try stack.objectContext.fetch(fetchRequest).map({ item in
                return WebPage(item: item)
            })
            showPages(pages, title: R.string.localizable.bookmarks(), at: menuItem)
        } catch let error as NSError {
            print("Failed to fetch: \(error) --> \(error.userInfo)")
        }
    }
    
    private func showHistory() {
        do {
            let fetchRequest = VisitedPage.fetchRequest()
            let pages = try stack.objectContext.fetch(fetchRequest).map({ item in
                return WebPage(item: item)
            })
            showPages(pages, title: R.string.localizable.history(), at: menuItem)
        } catch let error as NSError {
            print("Failed to fetch: \(error) --> \(error.userInfo)")
        }
    }
        
    @objc private func showHistoryBack() {
        guard webView.canGoBack else {
            self.showError("Cannot go back")
            return
        }
        showPages(webView.backForwardList.backList, title: R.string.localizable.jump_back(), at: backItem)
    }
    
    private func showHistoryForward() {
        guard webView.canGoForward else {
            self.showError("Cannot go forward")
            return
        }
        showPages(webView.backForwardList.forwardList, title: R.string.localizable.jump_forward(), at: forwardItem)
    }
    
    private func showPages(_ items: [WKBackForwardListItem], title: String, at item: UIBarButtonItem) {
        let pages = items.prefix(5).map { item in
            return WebPage(item: item)
        }
        showPages(pages, title: title, at: item)
    }
    
    private func showPages(_ pages: [WebPage], title: String, at item: UIBarButtonItem) {
        let vc = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for page in pages {
            let action = UIAlertAction(
                title: String(format: "%@\n%@", page.title, page.url),
                style: .default
            ) { action in
                self.load(page.url)
            }
            vc.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        vc.addAction(cancelAction)
        
        // iPad
        if let popoverController = vc.popoverPresentationController {
            popoverController.barButtonItem = item
        }
        
        present(vc, animated: true)
    }
    
    private func showSettings() {
        showError("Not implemented")
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
    }
    
    private func onTitleChanged() {
        guard let title = webView.title,
              let url = webView.url?.absoluteString else {
            return
        }
                
        print("Title changed to: '\(title)' for url: \(url)")
        
        // Store visited page
        let page = VisitedPage(context: stack.objectContext)
        page.url = url
        page.title = title
        page.created_at = Date()
        page.updated_at = Date()
                
        do {
            try stack.objectContext.save()
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
}
