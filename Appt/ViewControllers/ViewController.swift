//
//  ViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 28/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import Accessibility

class ViewController: UIViewController {

    var loadingIndicator: UIActivityIndicatorView?
    var isLoading: Bool = false {
        didSet {
            foreground {
                if self.isLoading {
                    Accessibility.announce("loading".localized)
                    
                    let indicator = UIActivityIndicatorView()
                    if #available(iOS 13.0, *) {
                        indicator.style = .large
                    } else {
                        indicator.style = .whiteLarge
                    }
                    indicator.accessibilityLabel = "loading".localized
                    
                    indicator.color = .primary
                    indicator.tintColor = .primary
                    indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    indicator.center = self.view.center
                    indicator.hidesWhenStopped = false
                    indicator.startAnimating()
                    indicator.translatesAutoresizingMaskIntoConstraints = false
                    
                    self.view.addSubview(indicator)
                    
                    indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
                    indicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    indicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    
                    self.view.bringSubviewToFront(indicator)
                    
                    self.loadingIndicator = indicator
                } else {
                    self.loadingIndicator?.removeFromSuperview()
                    self.loadingIndicator = nil
                }
            }
        }
    }
        
    // View did load: style
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isTranslucent = false
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Terug", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.accessibilityLabel = "Terug"
    }
    
    // View will appear: register notifications
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerStateNotifications()
    }
    
    // View will disappear: deregister notifications
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - State notifications

extension ViewController {
    
    // State: register notifications
    func registerStateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onStateForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateResign), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateTerminate), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    // State: deregister notifications
    func deregisterStateNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // State: entered foreground
    @objc func onStateForeground() {
        print("onStateForeground")
    }
    
    // State: became active
    @objc func onStateActive() {
        print("onStateActive")
    }
    
    // State: entered background
    @objc func onStateBackground() {
        print("onStateBackground")
    }
    
    // State: will resign
    @objc func onStateResign() {
        print("onStateResign")
    }
    
    // State: will terminate
    @objc func onStateTerminate() {
        print("onStateTerminate")
    }
}

// MARK: - Keyboard notifications

extension ViewController {
    
    // Keyboard: register notifications
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Keyboard: deregister notificaitons
    func deregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Keyboard: will show (notification)
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardWillShow(frame: keyboardFrame.cgRectValue)
        }
    }
    
    // Keyboard: will show (frame)
    @objc func keyboardWillShow(frame: CGRect) {
         print("keyboardWillShow", frame)
    }
    
    // Keyboard: will hide
    @objc func keyboardWillHide() {
        print("keyboardWillHide")
    }
}

// MARK: - Alerts

extension ViewController {
    
    func showError(_ error: Error) {
        Alert.error(error.localizedDescription, viewController: self)
    }
}
