//
//  StepperTableViewCell.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 16/11/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import UIKit

protocol StepperTableViewCellDelegate {
    func stepperValueChanged(_ value: Double)
}

class StepperTableViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var stepper: UIStepper!
    
    var delegate: StepperTableViewCellDelegate?
    
    private var title: String? = nil
        
    func setup(title: String, value: Int, min: Int, max: Int, step: Int) {
        self.title = title
        
        titleLabel.font = .rubik(weight: .regular, size: 18, style: .body)
        titleLabel.text = "\(title) \(value)%"
        
        stepper.value = Double(value)
        stepper.minimumValue = Double(min)
        stepper.maximumValue = Double(max)
        stepper.stepValue = Double(step)

        isAccessibilityElement = true
        shouldGroupAccessibilityChildren = true
        accessibilityTraits = .adjustable
        accessibilityLabel = title
        accessibilityValue = "\(value) %"
        accessibilityTraits = .adjustable
    }
        
    override func accessibilityIncrement() {
        adjust(stepper.stepValue)
    }

    override func accessibilityDecrement() {
        adjust(-stepper.stepValue)
    }
    
    private func adjust(_ step: Double) {
        stepper.value += step
        update()
    }
    
    private func update() {
        let value = Int(stepper.value)
        accessibilityValue = "\(value) %"
        
        if let title = self.title {
            titleLabel.text = "\(title) \(value)%"
        }
    }
    
    @IBAction private func onStepperChanged(_ sender: Any) {
        update()
        
        delegate?.stepperValueChanged(stepper.value)
    }
}
