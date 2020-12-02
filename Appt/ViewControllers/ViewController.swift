//
//  ViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 28/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import Accessibility
import FirebaseAnalytics

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
        registerKeyboardNotifications()
        registerAccessibilityNotifications()
    }
    
    // View will disappear: deregister notifications
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - State notifications

extension ViewController {
    
    // State: register notifications
    private func registerStateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onStateForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateResign(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateTerminate(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    // State: entered foreground
    @objc private func onStateForeground(_ notification: Notification) {
        onStateForeground()
    }
    
    @objc func onStateForeground() {
        // Can be overridden
    }
    
    // State: became active
    @objc private func onStateActive(_ notification: Notification) {
        onStateActive()
    }
    
    @objc func onStateActive() {
        // Can be overridden
    }
    
    // State: entered background
    @objc private func onStateBackground(_ notification: Notification) {
        onStateBackground()
    }
    
    @objc func onStateBackground() {
        // Can be overridden
    }
    
    // State: will resign
    @objc private func onStateResign(_ notification: Notification) {
        onStateResign()
    }
    
    @objc func onStateResign() {
        // Can be overridden
    }
    
    // State: will terminate
    @objc private func onStateTerminate(_ notification: Notification) {
        onStateTerminate()
    }
    
    @objc func onStateTerminate() {
        // Can be overridden
    }
}

// MARK: - Keyboard notifications

extension ViewController {
    
    // Keyboard: register notifications
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Keyboard: will show
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardWillShow(frame: keyboardFrame.cgRectValue)
    }
    
    @objc func keyboardWillShow(frame: CGRect) {
        // Can be overridden
    }
    
    // Keyboard: will hide
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardWillHide()
    }

    @objc func keyboardWillHide() {
        // Can be overridden
    }
}

// MARK: - Accessibility notifications

extension ViewController {
    
    // Accessibility: register notifications
    private func registerAccessibilityNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(announcementFinished(_:)),name: UIAccessibility.announcementDidFinishNotification, object: nil)
    }
    
    @objc private func announcementFinished(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let announcement = info[UIAccessibility.announcementStringValueUserInfoKey] as? String else { return }
        guard let success = info[UIAccessibility.announcementWasSuccessfulUserInfoKey] as? Bool else { return }
        
        announcementFinished(success: success, announcement: announcement)
    }
    
    @objc func announcementFinished(success: Bool, announcement: String) {
        // Can be overridden
    }
}

// MARK: - Alerts

extension ViewController {
    
    func showError(_ error: Error, callback: (() -> Void)? = nil) {
        showError(error.localizedDescription, callback: callback)
    }
    
    func showError(_ error: String, callback: (() -> Void)? = nil) {
        Alert.error(error, viewController: self, callback: callback)
    }
}
