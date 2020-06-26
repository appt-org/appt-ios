//
//  GestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit

protocol GestureViewDelegate {
    func onGesture(_ gesture: Gesture)
}

class GestureView: UIView {
    
    var delegate: GestureViewDelegate?
    
    // Use one finger to tap
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        recognizer.delegate = self
        recognizer.require(toFail: doubleTapRecognizer)
        recognizer.require(toFail: fourFingerTapRecognizer)
        return recognizer
    }()
    
    // Use one finger to double tap
    private lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
        recognizer.delegate = self
        recognizer.numberOfTapsRequired = 2
        recognizer.require(toFail: fourFingerTapRecognizer)
        return recognizer
    }()
    
    // Use four fingers to tap
    private lazy var fourFingerTapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onFourFingerTap(_:)))
        recognizer.delegate = self
        recognizer.numberOfTouchesRequired = 4
        return recognizer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isAccessibilityElement = true
        accessibilityLabel = "Maak een gebaar"
        //accessibilityTraits = [.adjustable]
        accessibilityTraits = .allowsDirectInteraction
        
        NotificationCenter.default.addObserver(self, selector: #selector(announcementDidFinishNotification), name: UIAccessibility.announcementDidFinishNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(elementFocusedNotification), name: UIAccessibility.elementFocusedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverStatusDidChangeNotification), name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)
        
        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(doubleTapRecognizer)
        addGestureRecognizer(fourFingerTapRecognizer)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        print("onTap")
        delegate?.onGesture(.tap)
    }
    
    @objc func onDoubleTap(_ sender: UITapGestureRecognizer) {
        print("onDoubleTap")
        delegate?.onGesture(.doubleTap)
    }
    
    @objc func onFourFingerTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        
        if location.y < frame.height/2 {
            delegate?.onGesture(.fourFingerTapTop)
        } else {
            delegate?.onGesture(.fourFingerTapBottom)
        }
    }
}

extension GestureView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (gestureRecognizer == tapRecognizer && otherGestureRecognizer == doubleTapRecognizer) {
//            return false
//        }
        return false
    }
}
// MARK: - Notifications

extension GestureView {
    
    @objc func announcementDidFinishNotification() {
        print("announcementDidFinishNotification")
    }
    
    @objc func elementFocusedNotification() {
        print("elementFocusedNotification")
    }
    
    @objc func voiceOverStatusDidChangeNotification() {
        print("voiceOverStatusDidChangeNotification")
    }
}

// MARK: - Touches

extension GestureView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("Touches began")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("Touches moved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("Touches ended")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("Touches cancelled")
    }
}

// MARK: - UIAccessibilityFocus

extension GestureView {
    
    override func accessibilityElementDidBecomeFocused() {
        super.accessibilityElementDidBecomeFocused()
        print("accessibilityElementDidBecomeFocused")
    }
    
    override func accessibilityElementDidLoseFocus() {
        super.accessibilityElementDidLoseFocus()
        print("accessibilityElementDidLoseFocus")
    }
    
    override func accessibilityElementIsFocused() -> Bool {
        print("accessibilityElementIsFocused")
        return super.accessibilityElementIsFocused()
    }
    
    override func accessibilityAssistiveTechnologyFocusedIdentifiers() -> Set<UIAccessibility.AssistiveTechnologyIdentifier>? {
        print("accessibilityAssistiveTechnologyFocusedIdentifiers")
        return super.accessibilityAssistiveTechnologyFocusedIdentifiers()
    }
}

// MARK: - UIAccessibilityAction

extension GestureView {
    
    override func accessibilityActivate() -> Bool {
        print("accessibilityActivate")
        return super.accessibilityActivate()
    }
    
    override func accessibilityIncrement() {
       super.accessibilityIncrement()
       print("accessibilityIncrement")
    }
    
    override func accessibilityDecrement() {
        super.accessibilityDecrement()
        print("accessibilityDecrement")
    }
    
    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        print("accessibilityScroll", direction.rawValue)
        return super.accessibilityScroll(direction)
    }
    
    override func accessibilityPerformEscape() -> Bool {
        super.accessibilityPerformEscape()
        print("accessibilityPerformEscape")
        return true
    }
    
    override func accessibilityPerformMagicTap() -> Bool {
        super.accessibilityPerformMagicTap()
        print("accessibilityPerformMagicTap")
        return true
    }
}

