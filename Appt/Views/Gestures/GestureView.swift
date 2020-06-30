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
    func onTouchesEnded()
}

class GestureView: UIView {
    
    var delegate: GestureViewDelegate?
    
    var gesture: Gesture {
        return getGesture()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    open func customInit() {
        isAccessibilityElement = true
        accessibilityLabel = gesture.description
        
        setup()
    }
    
    func getGesture() -> Gesture {
        fatalError("gesture() should be overridden")
    }
    
    func setup() {
        fatalError("setup() should be overridden")
    }
    
    class func create(_ gesture: Gesture) -> GestureView {
        switch gesture {
        case .singleTap:
            return SingleTapGestureView()
        case .doubleTap:
            return DoubleTapGestureView()
        case .fourFingerTapBottom:
            return FourTapBottomGestureView()
        case .fourFingerTapTop:
            return FourTapTopGestureView()
        }
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
        delegate?.onTouchesEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("Touches cancelled")
    }
}
