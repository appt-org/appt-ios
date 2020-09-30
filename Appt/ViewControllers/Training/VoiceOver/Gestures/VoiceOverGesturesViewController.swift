//
//  VoiceOverGesturesViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 23/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverGesturesViewController: TableViewController {
 
    private var gestures: KeyValuePairs<String, [Gesture]> {
        return [
            "gestures_explore".localized: [
                .fourFingerTapTop,
                .fourFingerTapBottom,
                .twoFingerSwipeUp,
                .twoFingerSwipeDown,
                .twoFingerTap,
                .threeFingerTap
            ],
            "gestures_scroll".localized: [
                .scrollUp,
                .scrollRight,
                .scrollDown,
                .scrollLeft
            ],
            "gestures_actions".localized: [
                .doubleTap,
                .tripleTap,
                .slide,
                .magicTap,
                .escape,
                .label
            ],
            "gestures_controls".localized: [
                .threeFingerDoubleTap,
                .threeFingerTripleTap,
                .doubleTapLongPress,
                .twoFingerTripleTap
            ],
            "gestures_rotor".localized: [
                .rotor,
                .swipeUp,
                .swipeDown
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
        
        cell.gesture = gestures[indexPath.section].value[indexPath.row]
        
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
