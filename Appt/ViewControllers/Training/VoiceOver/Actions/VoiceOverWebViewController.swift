//
//  VoiceOverActionViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 25/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import WebKit
import Accessibility

class VoiceOverWebViewController: ViewController {
 
    private var webView: WKWebView!
       
    @objc func elementFocusedNotification(_ notification: Notification) {
       print("elementFocusedNotification")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(elementFocusedNotification), name: UIAccessibility.elementFocusedNotification, object: nil)
        
//        guard UIAccessibility.isVoiceOverRunning else {
//            Alert.Builder()
//                .title("VoiceOver staat uit")
//                .message("Je moet VoiceOver aanzetten voordat je deze training kunt volgen.")
//                .action("Oké") { (action) in
//                    self.navigationController?.popViewController(animated: true)
//                }.present(in: self)
//            return
//        }
        
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
        
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .none
        view.addSubview(webView)

        let layoutGuide = view.safeAreaLayoutGuide

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true

        let content = """
            <p>Via de VoiceOver rotor kun je via de koppen navigeren.</p>
            <input/><input/><input/>
            <ol>
                <li>Activeer de VoiceOver rotor door met twee vingers te draaien.</li>
                <li>Draai met twee vingers naar links of rechts tot de optie 'Kopregels' is geselecteerd.</li>
                <li>Veeg met één vinger omlaag om naar de volgende kop te gaan.</li>
                <li>Veeg met één vinger omhoog om naar de vorige kop te gaan.</li>
            </ol>
            <h1 tabindex="0" id="h1">Kop 1</h1>
            <p>Deze informatie over kop 1 sla je over.</p>
            <h1 tabindex="1">Kop 2</h1>
            <p>Deze informatie over kop 2 sla je over.</p>
            <h1 tabindex="2">Kop 3</h1>
            <p>Deze informatie over kop 3 sla je over.</p>
        """
        
        let html = """
            <html lang="nl">
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1"/>
                    <link rel="stylesheet" type="text/css" href="style.css">
                    </style>
                </head>
            <body>
            """ + content + """
            </body>
            </html>
        """
        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        
        Accessibility.layoutChanged(webView)
        
        
        let element = UIAccessibility.focusedElement(using: .notificationVoiceOver)
        print("Focused element", element)
        
        delay(5.0) {
            let element = UIAccessibility.focusedElement(using: .notificationVoiceOver)
            print("Focused element after 5 seconds", element)
            
            
        }
        
    }
}

/// MARK: - WKScriptMessageHandler

extension VoiceOverWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let dictionary = message.body as? Dictionary<String, AnyObject> {
            print("didReceive dictionary", dictionary)
        } else {
            print("didReceive", message.body)
        }
    }
}
