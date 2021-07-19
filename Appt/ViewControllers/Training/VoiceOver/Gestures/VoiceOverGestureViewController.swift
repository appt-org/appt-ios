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
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var feedbackLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageHeightConstraint: NSLayoutConstraint!
    
    var gesture: Gesture!
    var gestures: [Gesture]?
    
    private var errorLimit = 5
    private var errorCount = 0

    private lazy var gestureView: GestureView = {
        let gestureView = gesture.view
        gestureView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gestureView)
        
        if let view = self.view {
            NSLayoutConstraint(item: gestureView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: gestureView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: gestureView, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: gestureView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        }
        
        view.bringSubviewToFront(gestureView)
        return gestureView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = nil
        
        titleLabel.accessibilityTraits = .header
        titleLabel.font = .openSans(weight: .bold, size: 20, style: .body)
        titleLabel.text = gesture.title
        
        descriptionLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        descriptionLabel.text = gesture.description
        
        feedbackLabel.font = .openSans(weight: .regular, size: 18, style: .body)
        feedbackLabel.isHidden = true
        
        imageView.image = gesture.image
        imageHeightConstraint.constant = view.frame.height / 3
        view.sendSubviewToBack(imageView)
        
        gestureView.delegate = self
        view.accessibilityElements = [gestureView]
        Accessibility.layoutChanged(gestureView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        imageHeightConstraint.constant = size.height / 3
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
            gestures.removeFirst()
            viewControllers[viewControllers.count-1] = UIStoryboard.voiceOverGesture(gesture: gestures[0], gestures: gestures)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    func incorrect(_ gesture: Gesture, feedback: String) {
        errorCount += 1
        
        // Announce & display feedback
        Accessibility.announce(feedback)

        if feedbackLabel.isHidden {
            feedbackLabel.text = nil
            feedbackLabel.isHidden = false
        }
        UIView.transition(with: self.feedbackLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.feedbackLabel.alpha = 0
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
                .action("stop".localized, style: .destructive) {
                    self.navigationController?.popViewController(animated: true)
                }
                .action("skip".localized) {
                    guard var viewControllers = self.navigationController?.viewControllers,
                          var gestures = self.gestures else {
                        return
                    }
                    if gestures.count > 1 {
                        gestures.removeFirst()
                        viewControllers[viewControllers.count-1] = UIStoryboard.voiceOverGesture(gesture: gestures[1], gestures: gestures)
                        self.navigationController?.setViewControllers(viewControllers, animated: true)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                .action("continue".localized) {
                    self.errorLimit = self.errorLimit * 2
                    Accessibility.screenChanged(self.gestureView)
                }.present(in: self)
        }
    }
}
