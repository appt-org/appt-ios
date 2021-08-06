//
//  VoiceOverGesturesViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 23/07/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

class VoiceOverGesturesViewController: TableViewController {
 
    private var gestures: KeyValuePairs<String, [Gesture]> {
        return [
            "gestures_explore".localized: [
                .oneFingerTouch,
                .oneFingerSwipeRight,
                .oneFingerSwipeLeft,
                .fourFingerTapTop,
                .fourFingerTapBottom,
                .twoFingerSwipeUp,
                .twoFingerSwipeDown,
                .twoFingerTap,
                .threeFingerTap
            ],
            "gestures_scroll".localized: [
                .threeFingerSwipeUp,
                .threeFingerSwipeRight,
                .threeFingerSwipeDown,
                .threeFingerSwipeLeft
            ],
            "gestures_actions".localized: [
                .oneFingerDoubleTap,
                .oneFingerTripleTap,
                .twoFingerDoubleTap,
                .twoFingerZShape,
                .twoFingerDoubleTapHold
            ],
            "gestures_controls".localized: [
                .threeFingerDoubleTap,
                .threeFingerTripleTap,
                .twoFingerTripleTap,
                .oneFingerDoubleTapHold
            ],
            "gestures_rotor".localized: [
                .twoFingerRotate,
                .oneFingerSwipeUp,
                .oneFingerSwipeDown
            ]
        ]
    }
    
    private var lastSelectedRow: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = lastSelectedRow {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VoiceOverGestureViewController {
            if let gesture = sender as? Gesture {
                vc.gesture = gesture
            } else if let gestures = sender as? [Gesture] {
                vc.gesture = gestures.first
                vc.gestures = gestures
            }
        }
    }
    
    @IBAction private func onPracticeTapped(_ sender: Any) {
        let allGestures = gestures.flatMap { key, value -> [Gesture] in
            return value
        }
        performSegue(.voiceOverGesture, sender: allGestures)
    }
}

// MARK: - UITableView

extension VoiceOverGesturesViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return gestures.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return gestures[section].key
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gestures[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let gesture = gestures[indexPath.section].value[indexPath.row]
        cell.setup(gesture)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension VoiceOverGesturesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedRow = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        
        let gesture = gestures[indexPath.section].value[indexPath.row]
        performSegue(.voiceOverGesture, sender: gesture)
    }
}
