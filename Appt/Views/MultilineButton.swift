//
//  MultilineButton.swift
//  Appt
//
//  Created by Yurii Kozlov on 4/26/21.
//  Copyright © 2021 Stichting Appt. All rights reserved.
//

import UIKit

class MultilineButton: UIButton {
    private var usedFont: UIFont?

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

        self.setDynamicFontSize(font: .sourceSansPro(weight: .semibold, size: 17, style: .body))
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

    func setDynamicFontSize(font: UIFont) {
        self.usedFont = font
        self.titleLabel?.font = font

        NotificationCenter.default.addObserver(self, selector: #selector(setButtonDynamicFontSize),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }

    @objc private func setButtonDynamicFontSize() {
        guard let font = self.usedFont else {
            fatalError("Font is needed to update sizing")
        }

        self.titleLabel?.font = font
    }
}
