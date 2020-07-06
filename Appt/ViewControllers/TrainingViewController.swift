//
//  TrainingViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class TrainingViewController: ViewController {

    @IBOutlet private var tableView: UITableView!
    
//    private var gestures: KeyValuePairs<String, [String]> {
//        return [
//            "Verkennen": [
//                "Een onderdeel selecteren en uitspreken",
//                "Het volgende onderdeel selecteren",
//                "Het vorige onderdeel selecteren",
//                "Het eerste onderdeel op het scherm selecteren",
//                "Het laatste onderdeel in het scherm selecteren",
//                "Het volledige scherm van bovenaf laten voorlezen",
//                "Het volledige scherm vanaf het geselecteerde onderdeel laten voorlezen",
//                "Het voorlezen pauzeren of hervatten",
//                "Extra informatie laten uitspreken, zoals de positie in een lijst en of er tekst is geselecteerd"
//            ],
//            "Scrollen": [
//                "Eén pagina omhoog scrollen",
//                "Eén pagina omlaag scrollen",
//                "Eén pagina naar links scrollen",
//                "Eén pagina naar rechts scrollen",
//            ],
//            "Handelingen": [
//                "Het geselecteerde onderdeel activeren",
//                "Dubbel tikken op het geselecteerde onderdeel",
//                "Een schuifknop slepen",
//                "De actuele handeling starten of stoppen, zoals muziek stoppen",
//                "Een melding sluiten of teruggaan naar het vorige scherm",
//                "Het label van een onderdeel wijzigen, zodat je het gemakkelijker kunt vinden"
//            ],
//            "Bediening": [
//                "Het geluid van VoiceOver in- of uitschakelen",
//                "Het schermgordijn in- of uitschakelen",
//                "Een standaardgebaar gebruiken",
//                "De onderdeelkiezer openen"
//            ],
//            "Rotor": [
//                "Een rotorinstelling kiezen",
//                "Naar het vorige onderdeel gaan of verhogen",
//                "Naar het volgende onderdeel gaan of verlagen"
//            ]
//        ]
//    }
    
    private var gestures: KeyValuePairs<String, [Any]> {
        return [
            "Verkennen": [
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
            "Handelingen": [
                "Het geselecteerde onderdeel activeren",
                "Dubbel tikken op het geselecteerde onderdeel",
                "Een schuifknop slepen",
                "De actuele handeling starten of stoppen, zoals muziek stoppen",
                "Een melding sluiten of teruggaan naar het vorige scherm",
                "Het label van een onderdeel wijzigen, zodat je het gemakkelijker kunt vinden"
            ],
            "Bediening": [
                "Het geluid van VoiceOver in- of uitschakelen",
                "Het schermgordijn in- of uitschakelen",
                "Een standaardgebaar gebruiken",
                "De onderdeelkiezer openen"
            ],
            "Rotor": [
                "Een rotorinstelling kiezen",
                "Naar het vorige onderdeel gaan of verhogen",
                "Naar het volgende onderdeel gaan of verlagen"
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
        tableView.refreshControl = refreshControl
    }
}

// MARK: - UITableViewDataSource

extension TrainingViewController: UITableViewDataSource {

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

extension TrainingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let object = gestures[indexPath.section].value[indexPath.row]
        if let gesture = object as? Gesture {
            performSegue(.gesture, sender: gesture)
        } else {
            performSegue(.gesture, sender: Gesture.singleTap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gestureViewController = segue.destination as? GestureViewController, let gesture = sender as? Gesture {
            gestureViewController.gesture = gesture
        }
    }
}
