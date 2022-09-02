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
    
    lazy private var titleSuffix: String = {
        return R.string.localizable.appt_suffix()
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
        
        backItem.title = R.string.localizable.back()
        backItem.accessibilityLabel = R.string.localizable.back()
        
        if let image = R.image.icon_back() {
            let imageView = UIImageView(image: image)
            imageView.isUserInteractionEnabled = true
            imageView.accessibilityTraits = .button
            imageView.tintColor = .primary
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(onBackTapped))
            imageView.addGestureRecognizer(tap)
            
            let press = UILongPressGestureRecognizer(target: self, action: #selector(onBackPressed))
            imageView.addGestureRecognizer(press)
            
            backItem.customView = imageView
        }
       
        //backItem.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showHistoryBack)))
        
        
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
    
    @objc private func onBackTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc private func onBackPressed() {
        showHistoryBack()
    }
    
    @IBAction private func onBack(_ sender: Any, for event: UIEvent) {
        
        
        print("onBack, event=\(event)")
        print("Touches", event.allTouches?.count)
        
        
        let longPress = (event.allTouches?.first?.tapCount ?? 1) == 0
        print("Long press", longPress)
        
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction private func onForward(_ sender: Any, for event: UIEvent) {
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
    
    @IBAction private func onBookmark(_ sender: Any, for event: UIEvent) {
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
            self.showBookmarks()
        }
        vc.addAction(bookmarksAction)
        
        let historyAction = UIAlertAction(title: R.string.localizable.history(), style: .default) { action in
            self.showHistory()
        }
        vc.addAction(historyAction)
        
        let settingsAction = UIAlertAction(title: R.string.localizable.settings(), style: .default) { action in
            self.showError("Not implemented")
        }
        vc.addAction(settingsAction)
        
        let refreshAction = UIAlertAction(title: R.string.localizable.reload(), style: .default) { action in
            UIAccessibility.post(notification: .announcement, argument: R.string.localizable.loading())
            self.webView.reload()
        }
        
        vc.addAction(refreshAction)
        
        let cancelAction = UIAlertAction(title: R.string.localizable.cancel(), style: .cancel)
        vc.addAction(cancelAction)
        
        // iPad
        if let popoverController = vc.popoverPresentationController {
            if let item = sender as? UIBarButtonItem {
                popoverController.barButtonItem = item
            } else {
                popoverController.sourceView = view
            }
        }
        
        present(vc, animated: true)
    }
    
    private func showBookmarks() {
        self.showError("Not implemented")
    }
    
    private func showHistory() {
        showHistoryBack()
    }
        
    @objc private func showHistoryBack() {
        guard webView.canGoBack else {
            self.showError("Cannot go back")
            return
        }
        showPages(webView.backForwardList.backList, at: backItem)
    }
    
    private func showHistoryForward() {
        guard webView.canGoForward else {
            self.showError("Cannot go forward")
            return
        }
        showPages(webView.backForwardList.forwardList, at: forwardItem)
    }
    
    private func showPages(_ items: [WKBackForwardListItem], at item: UIBarButtonItem) {
        let pages = items.prefix(5).map { item in
            return WebPage(item: item)
        }
        showPages(pages, at: item)
    }
    
    private func showPages(_ pages: [WebPage], at item: UIBarButtonItem) {
        let vc = UIAlertController(
            title: "History",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for page in pages {
            let action = UIAlertAction(title: page.title, style: .default) { action in
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
        guard var title = webView.title,
              let url = webView.url?.absoluteString else {
            return
        }
        
        if title.hasSuffix(titleSuffix) {
            title = title.dropLast(titleSuffix.count).description
        }
        
        print("Title changed to: '\(title)' for url: \(url)")
        
        // Store history
        guard let entity = NSEntityDescription.entity(forEntityName: "HistoryPage", in: stack.objectContext) else {
            return
        }
        let page = NSManagedObject(entity: entity, insertInto: stack.objectContext)
        page.setValue(url, forKey: "url")
        page.setValue(title, forKey: "title")
        
        do {
            try stack.objectContext.save()
            print("Saved!")
        } catch let error as NSError {
            print("Failed to save: \(error) --> \(error.userInfo)")
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
