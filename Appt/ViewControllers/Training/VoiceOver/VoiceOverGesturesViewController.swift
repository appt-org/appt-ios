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
                .swipeRight,
                .swipeLeft,
                .singleTap,
                .doubleTap,
                .fourFingerTapTop,
                .fourFingerTapBottom,
                .twoFingerSwipeUp,
                .twoFingerSwipeDown
            ],
            "Scrollen": [
                .scrollUp,
                .scrollRight,
                .scrollDown,
                .scrollLeft
            ],
            "Rotor": [
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = lastSelectedRow {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gestureViewController = segue.destination as? VoiceOverGestureViewController, let gesture = sender as? Gesture {
            gestureViewController.gesture = gesture
        }
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
        
        cell.gesture = gestures[indexPath.section].value[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension VoiceOverGesturesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedRow = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        
        let gesture = gestures[indexPath.section].value[indexPath.row]
        performSegue(.voiceOverGesture, sender: gesture)
    }
}
