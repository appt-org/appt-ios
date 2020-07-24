//
//  VoiceOverGesturesViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 23/07/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverGesturesViewController: ViewController {

    @IBOutlet private var tableView: UITableView!
        
    private var gestures: KeyValuePairs<String, [Gesture]> {
        return [
            "Verkennen": [
                Gesture.swipeRight,
                Gesture.swipeLeft,
                Gesture.singleTap,
                Gesture.doubleTap,
                Gesture.fourFingerTapTop,
                Gesture.fourFingerTapBottom
            ],
            "Scrollen": [
                Gesture.scrollUp,
                Gesture.scrollRight,
                Gesture.scrollDown,
                Gesture.scrollLeft
            ],
            "Rotor": [
                Gesture.swipeUp,
                Gesture.swipeDown
            ]
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set-up UITableView
        tableView.registerNib(TitleTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension VoiceOverGesturesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return gestures.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return gestures[section].key
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gestures[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(TitleTableViewCell.self, at: indexPath)
        
        let object = gestures[indexPath.section].value[indexPath.row]
        if let gesture = object as? Gesture {
            cell.gesture = gesture
        } else if let gesture = object as? String {
            cell.setup(gesture)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension VoiceOverGesturesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let object = gestures[indexPath.section].value[indexPath.row]
        if let gesture = object as? Gesture {
            performSegue(.voiceOverGesture, sender: gesture)
        } else {
            performSegue(.voiceOverGesture, sender: Gesture.singleTap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gestureViewController = segue.destination as? VoiceOverGestureViewController, let gesture = sender as? Gesture {
            gestureViewController.gesture = gesture
        }
    }
}
