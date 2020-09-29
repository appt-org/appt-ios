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

class VoiceOverActionViewController: ScrollViewController {
    
    var action: Action!
    lazy var actionView: VoiceOverView = {
        return action.view
    }()
    
    override func getView() -> UIView {
        return actionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = action.title
        actionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(elementFocusedNotification), name: UIAccessibility.elementFocusedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pasteboardChangedNotification), name: UIPasteboard.changedNotification, object: nil)
    }
    
    @objc func elementFocusedNotification(_ notification: Notification) {
        actionView.elementFocusedNotification(notification)
    }
    
    @objc func pasteboardChangedNotification(_ notification: Notification){
        actionView.pasteboardChangedNotification(notification)
    }
}

// MARK: - Keyboard

extension VoiceOverActionViewController {
    
    override func keyboardWillShow(frame: CGRect) {
        var contentInset = scrollView.contentInset
        contentInset.bottom = frame.size.height
        scrollView.contentInset = contentInset
    }
    
    override func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

// MARK: - VoiceOverViewDelegate

extension VoiceOverActionViewController: VoiceOverViewDelegate {
    func correct(_ action: Action) {
        self.action.completed = true
        
        Alert.toast("Training succesvol afgerond!", duration: 3.0, viewController: self) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func incorrect(_ action: Action) {
        // Ignored
    }
}
