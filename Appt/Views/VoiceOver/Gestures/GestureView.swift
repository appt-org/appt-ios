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
    
    func correct(_ recognizer: UIGestureRecognizer? = nil) {
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
        onTouches(touches)
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
            
            if touch.tapCount > 1 {
                print("onTouches tap count > 1")
            }
            
            if var points = map[fingerprint], let lastPoint = points.last, lastPoint.location != point.location {
                points.append(point)
                map[fingerprint] = points
            } else {
                map[fingerprint] = [point]
            }
        }
        
        setNeedsDisplay()
    }
    
    func showTouches(recognizer: UIGestureRecognizer) {
        map.removeAll()
        
        let circles = recognizer.isKind(of: UITapGestureRecognizer.self)
        print("showTouches, circles: \(circles)")
        
        for i in 0...recognizer.numberOfTouches-1 {
            let fingerprint = String(i)
            let location = recognizer.location(ofTouch: i, in: self)
            let tapCount = (recognizer as? UITapGestureRecognizer)?.numberOfTapsRequired ?? 1
            
            let point = Point(location: location, tapCount: tapCount)
            
            map[fingerprint] = [point]
        }
        
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.primary.cgColor)
        context?.setLineCap(.round)
        context?.beginPath()

        for key in map.keys {
            guard let points = map[key],
                  let firstPoint = points.first else {
                continue
            }
            
            if points.count > 1 {
                context?.move(to: firstPoint.location)
                for point in points {
                    if point.tapCount > 1 {
                        drawCircles(point, context: context)
                    } else {
                        drawLine(point, context: context)
                    }
                }
            } else {
                drawCircles(firstPoint, context: context)
            }
        }
        
        context?.strokePath()
    }
    
    private func drawLine(_ point: Point, context: CGContext?) {
        context?.setLineWidth(15.0)
        context?.addLine(to: point.location)
    }
    
    private func drawCircles(_ point: Point, context: CGContext?) {
        if point.tapCount > 0 {
            context?.move(to: point.location)
            
            for i in 0...point.tapCount-1 {
                context?.setLineWidth(5.0)
                
                let size:CGFloat = 25 * CGFloat(i+1)
                
                let circle = CGRect(x: point.location.x - size/2, y: point.location.y - size/2, width: size, height: size)
                context?.strokeEllipse(in: circle)
            }
        }
    }
}

// MARK: - GestureRecognizerTouchesDelegate
extension GestureView: GestureRecognizerTouchesDelegate {
    
    func onTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        print("onTouchesBegan")
        touchesBegan(touches, with: event)
    }
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        print("onTouchesMoved")
        touchesMoved(touches, with: event)
    }
    
    func onTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        print("onTouchesEnded")
        touchesEnded(touches, with: event)
    }
    
    func onTouchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        print("onTouchesCancelled")
        touchesCancelled(touches, with: event)
    }
}
