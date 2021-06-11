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
            setTitleTextAttributes( [.font: UIFont.sourceSansPro(weight: .regular, size: 14, style: .body),
            ], for: $0)
        })
        setTitleTextAttributes( [.font: UIFont.sourceSansPro(weight: .bold, size: 14, style: .body),
                                 .foregroundColor: UIColor.primary], for: .selected)
        sizeToFit()
    }
}
