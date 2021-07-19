//
//  SegmentedControl.swift
//  Appt
//
//  Created by Yurii Kozlov on 6/8/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class SegmentedControl: UISegmentedControl {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        let states: [UIControl.State] = [.disabled, .focused, .normal, .selected, .highlighted]
        states.forEach({
            setTitleTextAttributes( [.font: UIFont.openSans(weight: .regular, size: 18, scaled: false),
            ], for: $0)
        })
        setTitleTextAttributes( [.font: UIFont.openSans(weight: .bold, size: 18, scaled: false),
                                 .foregroundColor: UIColor.white], for: .selected)
        sizeToFit()
    }
}
