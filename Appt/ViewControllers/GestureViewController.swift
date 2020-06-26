//
//  SubjectViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class GestureViewController: ViewController {
    
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var gestureView: GestureView!
    
    var gesture: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Training"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        headerLabel.text = gesture
        descriptionLabel.text = "In deze training leer je \(gesture.lowercased())."
        gestureView.delegate = self
        
        view.accessibilityElements = [gestureView]
        
        UIAccessibility.announce("In deze training leer je \(gesture.lowercased())")
    }
}

// MARK: - GestureViewDelegate

extension GestureViewController: GestureViewDelegate {
    
    func onGesture(_ gesture: Gesture) {
        headerLabel.text = gesture.header
        descriptionLabel.text = gesture.description
        UIAccessibility.announce(gesture.announcement)
    }
}
