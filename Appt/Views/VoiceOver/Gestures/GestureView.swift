//
//  GestureView.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 24/06/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import UIKit
import AVFoundation

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
        accessibilityLabel = String(format: "%@: %@", gesture.title, gesture.description)
        
        isOpaque = false
        clearsContextBeforeDrawing = false
        backgroundColor = .clear
    }
    
    func correct(_ recognizer: UIGestureRecognizer? = nil) {
        if !completed {
            completed = true
            AudioServicesPlaySystemSound(SystemSoundID(1256))
            delegate?.correct(gesture)
        }
    }
    
    func incorrect(_ feedback: String) {
        if !completed {
            AudioServicesPlaySystemSound(SystemSoundID(1257))
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
        var longPress: Bool = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touchesBegan")
        map.removeAll()
        onTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("touchesMoved")
        onTouches(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touchesEnded")
        //onTouches(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        print("touchesCancelled")
        //map.removeAll()
        //onTouches(touches)
    }
    
    private func onTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            let fingerprint = String(format: "%p", touch)
            let location = touch.location(in: self)
            
            let point = Point(location: location, tapCount: touch.tapCount)
            
            if var points = map[fingerprint], let lastPoint = points.last, lastPoint.location != point.location {
                points.append(point)
                map[fingerprint] = points
            } else {
                map[fingerprint] = [point]
            }
        }
        
        setNeedsDisplay()
    }

    func showTouches(recognizer: UIGestureRecognizer, tapCount: Int = 1, longPress: Bool = false) {
        print("showTouches")
        map.removeAll()
        
        for i in 0...recognizer.numberOfTouches-1 {
            let fingerprint = String(i)
            let location = recognizer.location(ofTouch: i, in: self)
            
            let point = Point(location: location, tapCount: tapCount, longPress: longPress)
            
            map[fingerprint] = [point]
        }
        
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let color = UIColor.primary.cgColor
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(color)
        context?.setFillColor(color)
        context?.setLineCap(.round)
    
        for key in map.keys {
            guard let points = map[key],
                  let firstPoint = points.first else {
                continue
            }
            
            context?.beginPath()
            
            drawCircles(firstPoint, context: context)
            
            if points.count > 1 {
                context?.move(to: firstPoint.location)
                
                for point in points {
                    drawLine(point, context: context)
                }
            }
            
            context?.strokePath()
        }
    }
    
    private func drawLine(_ point: Point, context: CGContext?) {
        context?.setLineWidth(15.0)
        context?.addLine(to: point.location)
    }
    
    private func drawCircles(_ point: Point, context: CGContext?) {
        if point.tapCount > 0 {
            context?.move(to: point.location)
            
            for i in 0...point.tapCount-1 {
                context?.setLineWidth(10.0)
                
                let size = CGFloat(50 + i * 50)
                
                let circle = CGRect(x: point.location.x - size/2, y: point.location.y - size/2, width: size, height: size)
                context?.strokeEllipse(in: circle)
                
                if point.longPress, i == 0 {
                    context?.fillEllipse(in: circle)
                }
            }
        }
    }
}
