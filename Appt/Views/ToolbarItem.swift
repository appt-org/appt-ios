//
//  ToolbarItem.swift
//  ApptApp
//
//  Created by Jan Jaap de Groot on 05/09/2022.
//  Copyright © 2022 Stichting Appt. All rights reserved.
//

import Foundation
import UIKit

typealias ToolbarItemCallback = (ToolbarItem) -> ()

class ToolbarItem: UIBarButtonItem {
    
    var onTap: ToolbarItemCallback? = nil
    var onLongPress: ToolbarItemCallback? = nil
    
    var item: Item? = nil {
        didSet {
            guard let item = item else { return }
            
            self.image = item.image
            self.title = item.title
            self.accessibilityLabel = self.title
            
            if let secondary = item.secondary {
                let action = UIAccessibilityCustomAction(name: secondary, target: self, selector: #selector(onLongPressAction))
                self.accessibilityCustomActions = [action]
            }
        }
    }
    
    override var image: UIImage? {
        didSet {
            print("Did set image")
            
            guard let image = image else { return }
            
            let imageView = UIImageView(image: image)
            imageView.isUserInteractionEnabled = true
            imageView.accessibilityTraits = .button
            imageView.tintColor = .primary

            let tap = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
            imageView.addGestureRecognizer(tap)

            let press = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction))
            imageView.addGestureRecognizer(press)

            self.customView = imageView
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            print("Did set isEnabled")
            
            guard let view = customView else { return }
            
            view.isUserInteractionEnabled = isEnabled
            view.tintColor = isEnabled ? .primary : .disabled
            
//            if isEnabled {
//                view.accessibilityTraits = .button
//            } else {
//                view.accessibilityTraits = [.button, .notEnabled]
//            }
        }
    }
    
    
    @objc private func onTapAction() {
        onTap?(self)
    }
    
    @objc private func onLongPressAction() {
        onLongPress?(self)
    }
}
