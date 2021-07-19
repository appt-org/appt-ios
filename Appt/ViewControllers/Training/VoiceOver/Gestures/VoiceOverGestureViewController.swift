//
//  VoiceOverGestureViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import AVKit
import Accessibility

class VoiceOverGestureViewController: ViewController {
    
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var feedbackLabel: UILabel!
    
    var gesture: Gesture!
    var gestures: [Gesture]?
    
    private var errorLimit = 5
    private var errorCount = 0

    private lazy var gestureView: GestureView = {
        let gestureView = gesture.view
        gestureView.frame = view.frame
        view.addSubview(gestureView)
        view.bringSubviewToFront(gestureView)
        return gestureView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = gesture.title
        
        headerLabel.font = .openSans(weight: .semibold, size: 20, style: .body)
        headerLabel.text = gesture.description
        
        feedbackLabel.font = .openSans(weight: .semibold, size: 18, style: .body)
        feedbackLabel.isHidden = true
        
        gestureView.delegate = self
        view.accessibilityElements = [gestureView]
        Accessibility.layoutChanged(gestureView)
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
    
    @IBAction private func onExplanationTapped(_ sender: Any) {
        Alert.Builder()
            .title(gesture.title)
            .message(gesture.explanation)
            .action("continue".localized) {
                Accessibility.screenChanged(self.gestureView)
            }.present(in: self)
    }
}

// MARK: - GestureViewDelegate

extension VoiceOverGestureViewController: GestureViewDelegate {
    
    func correct(_ gesture: Gesture) {
        self.gesture.completed = true
        Events.log(.gestureCompleted, identifier: gesture.id, value: errorCount)
        
        // Check if single gesture
        guard var gestures = self.gestures else {
            Alert.toast("gesture_correct".localized, duration: 2.5, viewController: self) {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        // Check if all gestures have been completed
        guard gestures.count > 1 else {
            Alert.Builder()
                .title("gesture_completed".localized)
                .action("finish".localized) {
                    self.navigationController?.popViewController(animated: true)
                }.present(in: self)
            return
        }
        
        // Continue to next gesture
        guard var viewControllers = self.navigationController?.viewControllers else {
            return
        }
        
        Alert.toast("gesture_correct".localized, duration: 2.5, viewController: self) {
            gestures.remove(at: 0)
            viewControllers[viewControllers.count-1] = UIStoryboard.voiceOverGesture(gesture: gestures[0], gestures: gestures)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    func incorrect(_ gesture: Gesture, feedback: String) {
        errorCount += 1
        
        // Announce & display feedback
        Accessibility.announce(feedback)

        UIView.transition(with: self.feedbackLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.feedbackLabel.isHidden = false
            self.feedbackLabel.alpha = 0.1
        }, completion: { _ in
            UIView.transition(with: self.feedbackLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.feedbackLabel.text = feedback
                self.feedbackLabel.alpha = 1.0
            })
        })

        // Provide an option to stop after each five attempts
        if errorCount >= errorLimit {
            Alert.Builder()
                .title("gesture_incorrect".localized(errorCount))
                .action("stop".localized, style: .cancel) {
                    self.navigationController?.popViewController(animated: true)
                }
                .action("continue".localized) {
                    self.errorLimit = self.errorLimit * 2
                    Accessibility.screenChanged(self.gestureView)
                }.present(in: self)
            
        }
    }
}
