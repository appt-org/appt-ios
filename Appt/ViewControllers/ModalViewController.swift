//
//  ModalViewController.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 17/05/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit
import Rswift

class ModalViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeItem = UIBarButtonItem(
            title: R.string.localizable.close(),
            style: .done,
            target: self,
            action: #selector(onClose)
        )
        navigationItem.setLeftBarButton(closeItem, animated: true)
    }
    
    @objc private func onClose() {
        dismiss(animated: true)
    }
}
