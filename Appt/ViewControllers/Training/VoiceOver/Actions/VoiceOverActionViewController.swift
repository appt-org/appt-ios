//
//  VoiceOverActionViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 31/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Accessibility

class VoiceOverActionViewController: ViewController {
    
    @IBOutlet private var scrollView: UIScrollView!
    
    var action: Action!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = action.title
        
        guard UIAccessibility.isVoiceOverRunning else {
            Alert.Builder()
                .title("VoiceOver staat uit")
                .message("Je moet VoiceOver aanzetten voordat je deze training kunt volgen.")
                .action("Oké") { (action) in
                    self.navigationController?.popViewController(animated: true)
                }.present(in: self)
            return
        }
        
        let view = action.view
        view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(elementFocusedNotification), name: UIAccessibility.elementFocusedNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
        
    @objc func elementFocusedNotification(_ notification: Notification) {
        print("elementFocusedNotification")
        
        guard let data = notification.userInfo else {
            return
        }
        
        guard let focusedElement = data[UIAccessibility.focusedElementUserInfoKey] as? UIView else {
            return
        }
        
        guard let unfocusedElement = data[UIAccessibility.unfocusedElementUserInfoKey] as? UIView else {
           return
        }
    
        print("Focused element", focusedElement)
        print("Unfocused element", unfocusedElement)
        
        if action == .headings {
            if focusedElement.accessibilityTraits.contains(.header) && unfocusedElement.accessibilityTraits.contains(.header) {
                onCorrect()
            }
        } else if action == .links {
            if focusedElement.accessibilityTraits.contains(.link) && unfocusedElement.accessibilityTraits.contains(.link) {
                onCorrect()
            }
        }
    }
    
    private func onCorrect() {
        delay(1.0) {
            Alert.toast("Actie succesvol uitgevoerd!", duration: 3.0, viewController: self) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
