//
//  ArticleViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ArticleViewController: ViewController {
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()

        let webView = WKWebView(frame: view.frame, configuration: configuration)
        webView.scrollView.maximumZoomScale = 10.0
        webView.tintColor = .primary
        webView.isOpaque = true
        webView.backgroundColor = .clear
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        return webView
    }()

    var id: Int?
    var slug: String?
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPost()
    }
    
    private func getPost() {
        isLoading = true
        
        let callback = { (post: Post?, error: Error?) in
            if let post = post {
                self.onPost(post)
            } else if let error = error {
                self.onError(error)
            }
        }
        
        if let id = id {
            API.shared.getPost(id: id, callback: callback)
        } else if let slug = slug {
            API.shared.getPost(slug: slug, callback: callback)
        }
    }
    
    private func onPost(_ post: Post) {
        self.post = post

        guard let content = post.content?.rendered else {
            return
        }
        
        let html = """
                <html lang="nl">
                    <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
                        <link rel="stylesheet" type="text/css" href="style.css">
                    </head>
                <body>
                <h2>
                """ + post.title.rendered + """
                </h2>
                """ + content + """
                </body>
                </html>
        """
                
        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
    private func onError(_ error: Error) {
        print("onError", error)
        self.isLoading = false
    }
    
    @IBAction private func onShareTapped(_ sender: Any) {
        guard let url = post?.link else {
            return
        }
        
        let shareViewController = UIActivityViewController(activityItems: [url], applicationActivities: [])
        shareViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(shareViewController, animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension ArticleViewController: WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", webView.estimatedProgress == 1.0 {
            self.view.addSubview(webView)
            webView.constraintToSafeArea()
            self.view.bringSubviewToFront(webView)
            
            isLoading = false
        }
    }
        
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        
        print("WebView url", url.absoluteString)
        
        if navigationAction.navigationType == .linkActivated {
            if url.absoluteString.contains("appt.nl/kennisbank/") {
                let articleViewController = UIStoryboard.article(slug: url.lastPathComponent)
                navigationController?.pushViewController(articleViewController, animated: true)
            } else {
                openWebsite(url: url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
