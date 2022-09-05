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
            
            let view = UIImageView(image: item.image)
            view.isAccessibilityElement = true
            view.accessibilityTraits = .button
            view.accessibilityLabel = item.title
            view.isUserInteractionEnabled = true
            view.tintColor = .primary
                        
            let tap = UITapGestureRecognizer(target: self, action: #selector(onTapAction))
            view.addGestureRecognizer(tap)

            let press = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction))
            view.addGestureRecognizer(press)

            if let secondary = item.secondary {
                let action = UIAccessibilityCustomAction(
                    name: secondary.title,
                    target: self,
                    selector: #selector(onLongPressAction)
                )
                action.image = secondary.image
                view.accessibilityCustomActions = [action]
                
                self.secondaryAction = action
            }
            
            self.customView = view
            self.accessibilityLabel = view.accessibilityLabel
            self.title = view.accessibilityLabel
        }
    }
    
    private var secondaryAction: UIAccessibilityCustomAction? = nil
    
    override var isEnabled: Bool {
        didSet {
            guard let view = customView else { return }
            
            if isEnabled {
                view.accessibilityTraits = .button
                view.isUserInteractionEnabled = true
                view.tintColor = .primary
                
                if let secondaryAction = secondaryAction {
                    view.accessibilityCustomActions = [secondaryAction]
                }
            } else {
                view.accessibilityTraits = [.button, .notEnabled]
                view.isUserInteractionEnabled = false
                view.tintColor = .disabled
                view.accessibilityCustomActions = []
            }
        }
    }
    
    @objc private func onTapAction() {
        onTap?(self)
    }
    
    @objc private func onLongPressAction() -> Bool {
        onLongPress?(self)
        return true
    }
}
