//
//  VoiceOverGestureViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import AVKit

class VoiceOverGestureViewController: ViewController {
    
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    var gesture: Gesture!
    private var completed: Bool = false
    
    private lazy var gestureView: GestureView = {
        let gestureView = gesture.view
        gestureView.frame = view.frame
        view.addSubview(gestureView)
        view.bringSubviewToFront(gestureView)
        return gestureView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Training"
        
        headerLabel.text = gesture.action
        descriptionLabel.text = gesture.description
        gestureView.delegate = self
        
        view.accessibilityElements = [gestureView]
        UIAccessibility.focus(gestureView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(announcementDidFinishNotification(_:)), name: UIAccessibility.announcementDidFinishNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    @objc func announcementDidFinishNotification(_ sender: Notification) {
        print("announcementDidFinishNotification")
        
        guard let announcement = UIAccessibility.announcement(for: sender) else { return }
        print("Announcement", announcement)
        
        guard let success = UIAccessibility.success(for: sender) else { return }
        print("Success", success)
    
        if success, completed {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - GestureViewDelegate

extension VoiceOverGestureViewController: GestureViewDelegate {
    
    func onGesture(_ gesture: Gesture) {
        completed = true
        
        UIAccessibility.announce("Correct gebaar uitgevoerd!")
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        delay(10.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onInvalidGesture() {
        UIAccessibility.announce("Foutief gebaar uitgevoerd.")
    }
}
