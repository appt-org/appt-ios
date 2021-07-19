//
//  GestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit

protocol GestureViewDelegate {
    func correct(_ gesture: Gesture)
    func incorrect(_ gesture: Gesture, feedback: String)
}

class GestureView: UIView {
    
    var delegate: GestureViewDelegate?
    var gesture: Gesture!
    var completed = false
    
    convenience init(gesture: Gesture) {
        self.init()
        self.gesture = gesture
        
        isAccessibilityElement = true
        isMultipleTouchEnabled = true
        accessibilityTraits = .allowsDirectInteraction
        accessibilityLabel = gesture.description
        
        isOpaque = false
        clearsContextBeforeDrawing = false
        backgroundColor = .clear
    }
    
    func correct() {
        if !completed {
            completed = true
            delegate?.correct(gesture)
        }
    }
    
    func incorrect(_ feedback: String) {
        if !completed {
            delegate?.incorrect(gesture, feedback: feedback)
        }
    }
    
    override func accessibilityPerformEscape() -> Bool {
        // This gesture is ignored to avoid unwanted behaviour.
        return true
    }
    
    override func accessibilityPerformMagicTap() -> Bool {
        // This gesture is ignored to avoid unwanted behaviour.
        return true
    }
    
    var map: [String: [Point]] = [String: [Point]]()

    struct Point {
        var location: CGPoint
        var tapCount: Int
        
        var lineWidth: CGFloat {
            if tapCount <= 1 {
                return 10
            } else if tapCount == 2 {
                return 50
            } else {
                return 100
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        map.removeAll()
        onTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        onTouches(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        onTouches(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("TOUCHES CANCELLED")
    }
    
    private func onTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            let fingerprint = String(format: "%p", touch)
            let location = touch.location(in: self)
            
            let point = Point(location: location, tapCount: touch.tapCount)
            
            if touch.tapCount > 1 {
                print("tap count > 1")
            }
            
            if var points = map[fingerprint] {
                points.append(point)
                map[fingerprint] = points
            } else {
                map[fingerprint] = [point]
            }
        }
        
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10)
        context?.setStrokeColor(UIColor.primary.cgColor)
        context?.setLineCap(.round)
        context?.beginPath()
        
        for key in map.keys {
            guard let points = map[key],
                  let firstPoint = points.first else {
                continue
            }
            
            context?.move(to: firstPoint.location)
            for point in points.dropFirst() {
                context?.setLineWidth(point.lineWidth)
                context?.addLine(to: point.location)
            }
        }
        
        context?.strokePath()
    }
}
