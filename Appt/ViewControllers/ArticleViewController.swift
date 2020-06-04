//
//  ArticleViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import WebKit

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

    var id: Int!
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPost()
    }
    
    private func getPost() {
        isLoading = true
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        API.shared.getPost(id: id) { (post, error) in
            if let post = post {
                self.onPost(post)
            } else if let error = error {
                self.onError(error)
            }
        }
    }
    
    private func onPost(_ post: Post) {
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
                        <link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;700&display=swap" rel="stylesheet">
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
                                color: #FFA7DF;
                                font-weight: bold;
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
