//
//  FaceView.swift
//  FaceIt
//
//  Created by Ecsoya on 16/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var lineWidth: CGFloat = 5.0
    
    var scale: CGFloat = 0.90
    
    var color: UIColor? = UIColor.blue
    
    var mouthCurvature: Double = 1.0 //1 full smile, -1 full frown
    
    
    private var skullRadius: CGFloat {
        return min(bounds.width, bounds.height)/2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    private func pathToCircle( arcCenter: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0.0, endAngle: CGFloat(2.0 * M_PI), clockwise: false)
        path.lineWidth = self.lineWidth
        return path
    }
    
    private func pathToEye (eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        
        var eyeCenter = CGPoint(x: skullCenter.x, y: skullCenter.y - eyeOffset)
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOffset
        case .Right:
            eyeCenter.x += eyeOffset
        }
        return pathToCircle(arcCenter: eyeCenter, withRadius: eyeRadius)
    }
    
    private func pathToMouth () -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = self.lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        
        if color != nil {
            color!.set()
        }
        //Draw head
        pathToCircle(arcCenter: skullCenter, withRadius: skullRadius).stroke()
        //Draw eyes
        pathToEye(eye: .Left).stroke()
        pathToEye(eye: .Right).stroke()
        
        //Draw mouth
        pathToMouth().stroke()
    }
    
    
}
