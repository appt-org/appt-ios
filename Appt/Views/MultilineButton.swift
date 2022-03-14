//
//  MultilineButton.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/26/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class MultilineButton: UIButton {
    private var usedFont: UIFont? {
        get {
            return titleLabel?.font
        }
        set {
            titleLabel?.font = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.commonInit()
    }

    func commonInit() -> Void {
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.adjustsFontForContentSizeCategory = true
        self.titleLabel?.lineBreakMode = .byTruncatingTail

        self.usedFont = .openSans(weight: .semibold, size: 18, style: .body)
    }

    override var intrinsicContentSize: CGSize {
        guard let intrinsicContentSize = self.titleLabel?.intrinsicContentSize else {
            fatalError("Title label is nil")
        }

        let size = intrinsicContentSize
        return CGSize(width: size.width + contentEdgeInsets.left + contentEdgeInsets.right, height: size.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel?.preferredMaxLayoutWidth = self.titleLabel!.frame.size.width
    }
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

class UnderlinedMultilineButton: MultilineButton {
    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else {
            super.setTitle(title, for: state)
            return
        }
        
        let attrs = [NSAttributedString.Key.font : UIFont.openSans(weight: .semibold, size: 18, style: .body),
                     NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        let attributedTitle = NSMutableAttributedString(string: title, attributes:attrs)
        
        setAttributedTitle(attributedTitle, for: state)
    }
}
