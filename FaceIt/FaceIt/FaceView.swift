//
//  FaceView.swift
//  FaceIt
//
//  Created by Ecsoya on 16/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 5.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable  var scale: CGFloat = 0.90 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable  var color: UIColor? = UIColor.blue {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable var mouthCurvature: Double = 1.0 {//1 full smile, -1 full frown
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable var eyeOpen: Bool = true{
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable var eyeBrowTilt: Double = 0.5  // -1 full furrow, 1 fully relaxed
        {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    func pinchZoom(sender: UIPinchGestureRecognizer){
        scale = scale * sender.scale
        sender.scale = 1
    }
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
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    private func pathToCircle( arcCenter: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0.0, endAngle: CGFloat(2.0 * M_PI), clockwise: false)
        path.lineWidth = self.lineWidth
        return path
    }
    
    private func pathToEye (_ eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        
        let eyeCenter = getEyeCenter(eye)
        
        if eyeOpen {
            return pathToCircle(arcCenter: eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath();
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    private func getEyeCenter (_ eye: Eye) -> CGPoint  {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left:
            eyeCenter.x -= eyeOffset
        case .Right:
            eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForBrow(_ eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .Left:
            tilt *= -1.0
        case .Right:
            break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
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
        pathToEye(.Left).stroke()
        pathToEye(.Right).stroke()
        
        //Draw mouth
        pathToMouth().stroke()
        
        //Draw Brow Tilt
        pathForBrow(.Left).stroke()
        pathForBrow( .Right).stroke()
        
    }
    
    
}
