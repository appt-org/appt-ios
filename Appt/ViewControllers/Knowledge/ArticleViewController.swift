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
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
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
                        <link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;600;700&display=swap" rel="stylesheet">
                        <style>
                            :root {
                                color-scheme: light dark;
                                --code-background-color: #ddd;
                                --code-text-color: #666;
                            }

                            * {
                                box-sizing: inherit;
                                -webkit-font-smoothing: antialiased;
                                word-break: break-word;
                                font-family: 'Source Sans Pro', sans-serif;
                            }

                            body, html, table {
                                font-size: 1.05rem;
                            }

                            html {
                                font: -apple-system-body;
                            }

                            a {
                                color: #d023be;
                                font-weight: 600;
                            }

                            figure {
                                display: block !important;
                                width: 100%;
                                margin: 0;
                                padding: 0;
                                text-align: center;
                            }

                            img {
                                max-width: 100% !important;
                                max-height: 90vh !important;
                                width: auto !important;
                            }

                            figcaption {
                                color: #6d6d6d;
                            }
                            
                            iframe {
                                width: 100% !important;
                                height: 50vw !important;
                            }
                            
                            table {
                                table-layout: fixed;
                                border: 1px solid #ddd;
                                border-collapse: collapse;
                                border-spacing: 0;
                            }
                            th, td {
                                text-align: left;
                                border: 1px solid #ddd;
                                padding: 3px 6px;
                            }

                            pre {
                                font-family: monospace;
                                font-size: 0.9rem;
                                display: block;
                                max-width: 100%;
                                overflow: auto;
                                padding: 1em;
                                page-break-inside: avoid;
                                word-wrap: break-word;
                                background: var(--code-background-color);
                                border: 1px solid var(--code-background-color);
                                border-left: 3px solid #d023be;
                                color: var(--code-text-color);
                            }

                            @media screen and (prefers-color-scheme: dark) {
                                :root {
                                    --code-background-color: #222;
                                    --code-text-color: #999;
                                }
                            }
                        </style>
                    </head>
                <body>
                <h2>
                """ + post.title.rendered + """
                </h2>
                """ + content + """
                </body>
                </html>
        """
                
        webView.loadHTMLString(html, baseURL: nil)
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
