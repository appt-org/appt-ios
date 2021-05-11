//
//  PrimaryMultilineButton.swift
//  Appt
//
//  Created by Yurii Kozlov on 5/11/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class PrimaryMultilineButton: MultilineButton {
    override func commonInit() {
        super.commonInit()

        self.layer.cornerRadius = 17
        self.setTitleColor(.background, for: .normal)
        self.backgroundColor = .foreground
    }
}
