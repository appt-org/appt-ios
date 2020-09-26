//
//  VoiceOverGestureViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import AVKit
import Accessibility

class VoiceOverGestureViewController: ViewController {
    
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    var gesture: Gesture!
    var gestures: [Gesture]?
    
    private let ERROR_THRESHOLD = 3
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
        
        headerLabel.font = .sourceSansPro(weight: .bold, size: 20, style: .headline)
        headerLabel.text = gesture.title
        
        descriptionLabel.font = .sourceSansPro(weight: .regular, size: 18, style: .title2)
        descriptionLabel.text = gesture.description
        
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
            .action("Doorgaan") { (action) in
                Accessibility.screenChanged(self.gestureView)
            }.present(in: self)
    }
}

// MARK: - GestureViewDelegate

extension VoiceOverGestureViewController: GestureViewDelegate {
    
    func correct(_ gesture: Gesture) {
        self.gesture.completed = true
        
        // Check if single gesture
        guard var gestures = self.gestures else {
            Alert.toast("Correct gebaar!", duration: 2.5, viewController: self) {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        // Check if all gestures have been completed
        guard gestures.count > 1 else {
            Alert.Builder()
                .title("Training afgerond")
                .message("Je hebt alle gebaren succesvol uitgevoerd!")
                .action("Afronden") { (action) in
                    self.navigationController?.popViewController(animated: true)
                }.present(in: self)
            return
        }
        
        // Continue to next gesture
        guard var viewControllers = self.navigationController?.viewControllers else {
            return
        }
        
        Alert.toast("Correct gebaar!", duration: 2.5, viewController: self) {
            gestures.remove(at: 0)
            viewControllers[viewControllers.count-1] = UIStoryboard.voiceOverGesture(gesture: gestures[0], gestures: gestures)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
    
    func incorrect(_ gesture: Gesture, feedback: String = "Fout gebaar") {
        if errorCount < ERROR_THRESHOLD {
            Alert.toast(feedback, duration: 2.5, viewController: self) {
                Accessibility.screenChanged(self.gestureView)
            }
        } else {
            Alert.Builder()
            .title(feedback)
            .message("Je hebt het gebaar \(errorCount) keer fout uitgevoerd. Wil je doorgaan of stoppen?")
            .action("Stoppen", style: .cancel) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            .action("Doorgaan") { (action) in
                Accessibility.screenChanged(self.gestureView)
            }.present(in: self)
        }
        
        errorCount += 1
    }
}
