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
        
        if !UIAccessibility.isVoiceOverRunning {
            let alertController = UIAlertController (title: "VoiceOver staat uit", message: "Je moet VoiceOver aanzetten voordat je deze training kunt volgen.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Oké", style: .cancel) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)

            present(alertController, animated: true)
        }
    }
}
