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
    func onInvalidGesture()
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
        fatalError("getGesture() should be overridden")
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
        case .scrollUp:
            return ScrollUpGestureView()
        case .scrollRight:
            return ScrollRightGestureView()
        case .scrollDown:
            return ScrollDownGestureView()
        case .scrollLeft:
            return ScrollLeftGestureView()
        }
    }
}
