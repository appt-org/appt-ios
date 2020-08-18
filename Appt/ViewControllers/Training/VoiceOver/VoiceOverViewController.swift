//
//  VoiceOverViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 18/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverStatusChanged), name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)
        
        checkVoiceOver()
    }
    
    override func onStateActive() {
        checkVoiceOver()
    }
    
    @objc func voiceOverStatusChanged(_ sender: Notification) {
        print("VoiceOver status changed")
        checkVoiceOver()
    }
    
    private func checkVoiceOver() {
        if !UIAccessibility.isVoiceOverRunning {
            print("VoiceOver is NOT running")
            enableVoiceOver()
            
            
        } else {
            print("VoiceOver is running")
        }
    }
    
    private func enableVoiceOver() {
        let alertController = UIAlertController (title: "VoiceOver staat uit", message: "Voor deze training moet je VoiceOver aanzetten. Dat doe je zo:\n\n1. Open de Instellingen app\n2. Tik op Toegankelijkheid\n3. Tik op VoiceOver\n4. Zet de schakelaar aan\n\nJe kunt het ook aan Siri vragen, zeg:\n\"Hey Siri, zet VoiceOver aan\"", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Open Instellingen app", style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
             
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Annuleren", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}
