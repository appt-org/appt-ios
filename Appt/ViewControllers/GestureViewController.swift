//
//  SubjectViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import AVKit

class GestureViewController: ViewController {
    
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    var gesture: Gesture!
    var completed: Bool = false
    
    private lazy var gestureView: GestureView = {
        let gestureView = GestureView.create(gesture)
        gestureView.frame = view.frame
        view.addSubview(gestureView)
        view.bringSubviewToFront(gestureView)
        return gestureView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Training"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        headerLabel.text = gesture.action
        descriptionLabel.text = gesture.description
        gestureView.delegate = self
        
        view.accessibilityElements = [gestureView]
        UIAccessibility.focus(gestureView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(announcementDidFinishNotification(_:)), name: UIAccessibility.announcementDidFinishNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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

extension GestureViewController: GestureViewDelegate {
    
    func onGesture(_ gesture: Gesture) {
        completed = true
        
        UIAccessibility.announce("Correct gebaar uitgevoerd!")
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        
        delay(10.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onTouchesEnded() {
        UIAccessibility.announce("Foutief gebaar uitgevoerd.")
    }
}
