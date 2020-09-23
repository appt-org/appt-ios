//
//  Alert.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 19/08/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import Accessibility

class Alert {

    public static func toast(_ message: String, duration: Double, viewController: UIViewController, callback: (() -> Void)? = nil) {
        let alert = Builder()
            .message(message)
            .backgroundColor(.clear)
            .alpha(0.5)
            .cornerRadius(15)
            .build()

        viewController.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true)
            callback?()
        }
    }
    
    class Builder {
        
        private var title: String?
        private var message: String?
        private var preferredStyle: UIAlertController.Style = .alert
        private var tintColor: UIColor = .primary
        private var backgroundColor: UIColor = .clear
        private var alpha: CGFloat = 1.0
        private var cornerRadius:CGFloat = 0.0
        private var sourceView: UIView?
        private var sourceRect: CGRect?
        private var actions: [UIAlertAction] = [UIAlertAction]()
        
        init() {
            // Empty
        }
        
        func title(_ title: String) -> Builder {
            self.title = title
            return self
        }
        
        func message(_ message: String) -> Builder {
            self.message = message
            return self
        }
        
        func preferredStyle(_ style: UIAlertController.Style) -> Builder {
            self.preferredStyle = style
            return self
        }
        
        func tintColor(_ tintColor: UIColor) -> Builder {
            self.tintColor = tintColor
            return self
        }
        
        func backgroundColor(_ backgroundColor: UIColor) -> Builder {
            self.backgroundColor = backgroundColor
            return self
        }
        
        func alpha(_ alpha: CGFloat) -> Builder {
            self.alpha = alpha
            return self
        }
        
        func cornerRadius(_ cornerRadius: CGFloat) -> Builder {
            self.cornerRadius = cornerRadius
            return self
        }
                
        func sourceView(_ sourceView: UIView) -> Builder {
            self.sourceView = sourceView
            return self
        }
        
        func sourceRect(_ sourceRect: CGRect) -> Builder {
            self.sourceRect = sourceRect
            return self
        }
        
        
        func defaultAction(_ title: String = "Oké", handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return action(title, style: .default, handler: handler)
        }
        
        func cancelAction(_ title: String = "Annuleren", handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return action(title, style: .cancel, handler: handler)
        }
        
        func destructiveAction(_ title: String = "Verwijderen", handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return action(title, style: .destructive, handler: handler)
        }
        
        func action(_ title: String, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            let action = UIAlertAction(title: title, style: style, handler: handler)
            actions.append(action)
            return self
        }
        
        
        func build() -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            alert.view.tintColor = tintColor
            alert.view.backgroundColor = backgroundColor
            alert.view.alpha = alpha
            alert.view.layer.cornerRadius = cornerRadius
            
            if let sourceView = sourceView {
                alert.popoverPresentationController?.sourceView = sourceView
            }
            
            if let sourceRect = self.sourceRect {
                alert.popoverPresentationController?.sourceRect = sourceRect
            }
            
            actions.forEach { (action) in
                alert.addAction(action)
            }
            
            return alert
        }
        
        func present(in viewController: UIViewController, animated: Bool = true, completion:(() -> Void)? = nil) {
            viewController.present(build(), animated: animated, completion: completion)
        }
    }
}