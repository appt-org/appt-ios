//
//  VoiceOverActionsViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 18/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

class VoiceOverActionsViewController: ViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard UIAccessibility.isVoiceOverRunning else {
            Alert.Builder()
                .title("VoiceOver staat uit")
                .message("Je moet VoiceOver aanzetten voordat je deze training kunt volgen.")
                .action("Oké") { (action) in
                    self.navigationController?.popViewController(animated: true)
                }.present(in: self)
            return
        }
    }
}
