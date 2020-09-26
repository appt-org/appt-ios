//
//  WebViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/09/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import WebKit
import Accessibility

class WebViewController: ViewController {
 
    private lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        
        // Capture console.log
        let logScript = WKUserScript(source: """
            function captureLog(msg) {
                window.webkit.messageHandlers.log.postMessage(msg);
            }
            window.console.log = captureLog;
            console.log('injected console log');
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.addUserScript(logScript)
        contentController.add(self, name: "log")

        // Capture focus events
        let focusScript = WKUserScript(source: """
            window.onload = function(e) {
                window.webkit.messageHandlers.focus.postMessage({"status": "loaded"});
            }

            document.addEventListener('focusin', function(e) {
                window.webkit.messageHandlers.focus.postMessage({"focus": "element"});
                console.log('focusin!')
            });

            document.getElementById('h1').addEventListener('click', function(e) {
                console.log('click');
            });

            document.getElementById('h1').addEventListener('touchstart', function(e) {
                console.log('touchstart');
            });

            document.getElementById('h1').addEventListener('mouseover', function(e) {
                console.log('onmouseover');
            });

            console.log('focus injected');
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(focusScript)
        contentController.add(self, name: "focus")
        
        // Configure WKWebView
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        let webView = WKWebView(frame: view.frame, configuration: configuration)
        webView.scrollView.maximumZoomScale = 10.0
        webView.tintColor = .primary
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        view.addSubview(webView)

        let layoutGuide = view.safeAreaLayoutGuide

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        return webView
    }()

    func load(_ content: String, title: String) {
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
        
        Accessibility.layoutChanged(webView)
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
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
        
        if navigationAction.navigationType == .linkActivated {
            if url.absoluteString.contains("appt.nl/kennisbank/") {
                let articleViewController = UIStoryboard.article(type: .post, slug: url.lastPathComponent)
                navigationController?.pushViewController(articleViewController, animated: true)
            } else {
                openWebsite(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}


/// MARK: - WKScriptMessageHandler

extension WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let dictionary = message.body as? Dictionary<String, AnyObject> {
            print("didReceive dictionary", dictionary)
        } else {
            print("didReceive", message.body)
        }
    }
}
