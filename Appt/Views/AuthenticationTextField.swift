//
//  AuthenticationTextField.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/28/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

final class AuthenticationTextField: UITextField {
    private let rightButton = UIButton(type: .custom)

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    func commonInit() {
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.textFieldDisabled.cgColor
        self.font = .sourceSansPro(weight: .regular, size: 17, style: .body)
    }

    func setSecureTextEntry() {
        rightButton.setImage(UIImage(named: "ic_hidden"), for: .normal)
        rightButton.accessibilityLabel = "toggle_password_visible_accessibility_title".localized
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        rightViewMode = .always
        rightView = rightButton
        isSecureTextEntry = true
    }

    @objc
    private func toggleShowHide(button: UIButton) {
        isSecureTextEntry = !isSecureTextEntry

        if let existingText = text, isSecureTextEntry {
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }

        if isSecureTextEntry {
            rightButton.setImage(UIImage(named: "ic_hidden"), for: .normal)
            rightButton.accessibilityLabel = "toggle_password_visible_accessibility_title".localized
        } else {
            rightButton.setImage(UIImage(named: "ic_visible"), for: .normal)
            rightButton.accessibilityLabel = "toggle_password_hidden_accessibility_title".localized
        }

        self.layoutIfNeeded()
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 10

        return rect
    }

    let genericTextPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    let secureTextPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 45)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textContentType == .password ? secureTextPadding : genericTextPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textContentType == .password ? secureTextPadding : genericTextPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.textContentType == .password ? secureTextPadding : genericTextPadding)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            self.font = .sourceSansPro(weight: .regular, size: 17, style: .body)

            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                if !self.isEditing {
                    self.layer.borderColor = UIColor.textFieldDisabled.cgColor
                }
            }
        }
    }
}
