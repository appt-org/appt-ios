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
//        guard let path = Bundle.main.path(forResource: "style", ofType: "css") else {
//            return WKWebView()
//        }
//
//        let cssString = try! String(contentsOfFile: path).components(separatedBy: .newlines).joined()
//        let source = """
//          var style = document.createElement('style');
//          style.innerHTML = '\(cssString)';
//          document.head.appendChild(style);
//        """
//
//        let userScript = WKUserScript(source: source,
//                                      injectionTime: .atDocumentEnd,
//                                      forMainFrameOnly: true)
//
//        let userContentController = WKUserContentController()
//        userContentController.addUserScript(userScript)

        let configuration = WKWebViewConfiguration()
        //configuration.userContentController = userContentController

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
        print("onPost", post)
        self.post = post
        
//        let label = UILabel()
//        label.backgroundColor = .clear
//        label.numberOfLines = 2
//        label.font = UIFont.sourceSansPro(weight: .bold, size: 16)
//        label.textAlignment = .center
//        label.textColor = .black
//        label.text = post.title.rendered.htmlDecoded
//        navigationItem.titleView = label
        
        //self.title = post.title.rendered.htmlDecoded
        
        guard let content = post.content?.rendered else {
            return
        }
        
        let html = """
                <html>
                    <head>
                        <meta name="viewport"  content="width=device-width, initial-scale=1, maximum-scale=1"/>
                        <link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;600;700&display=swap" rel="stylesheet">
                        <style>
                            * {
                                box-sizing: inherit;
                                -webkit-font-smoothing: antialiased;
                                word-break: break-word;
                                font-family: 'Source Sans Pro', sans-serif;
                            }

                            body, html, table {
                                font-size: 1.05rem;
                            }

                            a {
                                color: #E671D5;
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
                                border: 1px solid #dcd7ca;
                                border-collapse: collapse;
                                border-spacing: 0;
                            }
                            th, td {
                                text-align: left;
                                border: 1px solid #dcd7ca;
                                border-color: #dbdbdb;
                                padding: 3px 6px;
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", webView.estimatedProgress == 1.0 {
            isLoading = false
            view.addSubview(webView)
            webView.constraintToSafeArea()
            
            UIAccessibility.focus(webView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
}

// MARK: - WKNavigationDelegate

extension ArticleViewController: WKNavigationDelegate {
    
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
