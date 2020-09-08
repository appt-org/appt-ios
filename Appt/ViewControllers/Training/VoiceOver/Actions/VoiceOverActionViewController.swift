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
        view.delegate = self
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
