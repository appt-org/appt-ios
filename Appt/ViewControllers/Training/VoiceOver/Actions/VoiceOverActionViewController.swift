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
    var actionView: VoiceOverView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = action.title
        
//        guard UIAccessibility.isVoiceOverRunning else {
//            Alert.Builder()
//                .title("VoiceOver staat uit")
//                .message("Je moet VoiceOver aanzetten voordat je deze training kunt volgen.")
//                .action("Oké") { (action) in
//                    self.navigationController?.popViewController(animated: true)
//                }.present(in: self)
//            return
//        }
        
        actionView = action.view
        actionView.delegate = self
        actionView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(actionView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: actionView.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: actionView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: actionView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionView.bottomAnchor),
            actionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        Accessibility.layoutChanged(actionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(elementFocusedNotification), name: UIAccessibility.elementFocusedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pasteboarChangedNotification), name: UIPasteboard.changedNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    @objc func elementFocusedNotification(_ notification: Notification) {
        actionView.elementFocusedNotification(notification)
    }
    
    @objc func pasteboarChangedNotification(_ notification: Notification){
        actionView.pasteboarChangedNotification(notification)
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
