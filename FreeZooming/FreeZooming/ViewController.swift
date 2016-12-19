//
//  ViewController.swift
//  FreeZooming
//
//  Created by Ecsoya on 18/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class ViewController: UIViewController , UIGestureRecognizerDelegate{

    @IBOutlet weak var drawingPaint: UIImageView!
    
    // Zomming
    var previousCenter = CGPoint(x: 0,y: 0)
    var previousTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    var maxScale:CGFloat = 6.0
    let minScale:CGFloat = 0.5

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(scaleImage))
        self.view.addGestureRecognizer(pinch)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSmartZoomAction))
       tap.numberOfTapsRequired = 1
       tap.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(tap)
        
        //let zoom = UIFreeZoomMoveGesture(target: self, action: #selector(zoomMoveAction))
        //self.view.addGestureRecognizer(zoom)
        //zoom.exclusives.append(paletteView)
    }
    
    var lastScale: CGFloat?
    var lastPoint: CGPoint?
    
    func scaleImage(sender: UIPinchGestureRecognizer) {
        if UIGestureRecognizerState.began == sender.state {
            lastScale = 1.0
            lastPoint = sender.location(in: drawingPaint)
        }
        
        //Scale
        let scale = 1.0 - (lastScale! - sender.scale)
        
        self.view.transform = self.view.transform.scaledBy(x: scale, y: scale)
        
        lastScale = sender.scale
        
        //Translate
        let point = sender.location(in: self.view)
        self.view.transform = self.view.transform.translatedBy(x: point.x - lastPoint!.x, y: point.y - lastPoint!.y)
        lastPoint = sender.location(in: self.view)
        
        sender.scale = 1.0
    }
    
    func tapSmartZoomAction(sender:UITapGestureRecognizer){
        let imageViewSize = drawingPaint.frame.size
        let screenSize = self.view.frame.size
        let imageSize = drawingPaint.image!.size
        let currentScale = imageViewSize.width/screenSize.width
        if (currentScale != 1.0) {
            self.previousCenter = drawingPaint.center
            self.previousTransform = drawingPaint.transform
            
            drawingPaint.center = self.view.center
            let fitScale = min(screenSize.width/CGFloat(imageSize.width),
                               screenSize.height/CGFloat(imageSize.height))
            drawingPaint.transform = CGAffineTransform.init(scaleX: fitScale, y: fitScale)
        } else {
            drawingPaint.center = self.previousCenter
            drawingPaint.transform = self.previousTransform
        }
    }
    func zoomMoveAction(sender:UIFreeZoomMoveGesture){
        print("Scaled: \(sender.scale)")
        print("Moved: \(sender.moved.x), \(sender.moved.y)")
        let currentScale = drawingPaint.frame.width/self.view.frame.width
        if (sender.scale > 1.0) {
            if (currentScale > maxScale) {
                drawingPaint.center.x += sender.moved.x
                drawingPaint.center.y += sender.moved.y
                sender.scale = 1
                return
            }
        }
        
        if (sender.scale < 1.0) {
            if (currentScale < minScale) {
                drawingPaint.center.x += sender.moved.x
                drawingPaint.center.y += sender.moved.y
                sender.scale = 1
                return
            }
        }
        let centerX = sender.center.x - drawingPaint.center.x
        let centerY = sender.center.y - drawingPaint.center.y
        
        drawingPaint.center.x += sender.moved.x // + centerX*sender.scale
        drawingPaint.center.y += sender.moved.y // + centerY*sender.scale
        
        drawingPaint.transform = drawingPaint.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }


}
class UIFreeZoomMoveGesture: UIGestureRecognizer {
    private var previousFirstFinger: CGPoint? = nil
    private var previousSecondFinger: CGPoint? = nil
    
    var scale = CGFloat(1.0)
    var moved = CGPoint(x:0, y:0)
    var center = CGPoint(x:0, y:0)
    var exclusives = [UIView]()
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        var firstFinger: UITouch? = nil
        var secondFinger: UITouch? = nil
        
        for touch in event.allTouches! {
            if (firstFinger == nil) {
                firstFinger = touch
            } else if (secondFinger == nil) {
                secondFinger = touch
                break
            }
        }
        
        if (firstFinger == nil || secondFinger == nil) {
            self.state = .failed
            return;
        }
        
        if (previousFirstFinger == nil) {
            previousFirstFinger = firstFinger!.location(in: self.view)
            previousSecondFinger = secondFinger!.location(in: self.view)
            self.state = .possible
            return;
        }
        
        // We do not attempt to determine if the first finger, second finger, or
        // both fingers are the reason for this method call. For this reason, we
        // do not know if either is stale or updated, and thus we cannot rely
        // upon the UITouch's previousLocationInView method. Therefore, we need to
        // cache the latest UITouch's locationInView information each pass.
        
        // Break down the previous finger coordinates...
        let A0x = previousFirstFinger!.x;
        let A0y = previousFirstFinger!.y;
        let A1x = previousSecondFinger!.x;
        let A1y = previousSecondFinger!.y;
        
        // Update our cache with the current fingers for next pass through here...
        previousFirstFinger = firstFinger!.location(in: self.view)
        previousSecondFinger = secondFinger!.location(in: self.view)
        
        // Break down the current finger coordinates...
        let B0x = previousFirstFinger!.x;
        let B0y = previousFirstFinger!.y;
        
        let B1x = previousSecondFinger!.x;
        let B1y = previousSecondFinger!.y;
        
        // Calculate the zoom resulting from the two fingers moving toward or away from each other...
        //        let oldScale = scale
        
        var dx2 = (B0x-B1x)*(B0x-B1x)
        var dy2 = (B0y-B1y)*(B0y-B1y)
        let distance1 = sqrt(dx2 + dy2)
        dx2 = (A0x-A1x)*(A0x-A1x)
        dy2 = (A0y-A1y)*(A0y-A1y)
        let distance0 = sqrt(dx2 + dy2)
        
        // Calculate the old and new centroids so that we can compare the centroid's movement...
        let oldCentroid = CGPoint(x:(A0x + A1x)/2, y:(A0y + A1y)/2)
        let newCentroid = CGPoint(x:(B0x + B1x)/2, y:(B0y + B1y)/2)
        
        // Calculate the pan values to apply to the view so that the combination of zoom and pan
        // appear to apply to the centroid rather than the center of the view...
        let dx = newCentroid.x - oldCentroid.x
        let dy = newCentroid.y - oldCentroid.y
        
        /*
         if (sqrt(dx*dx + dy*dy) > 40) {
         self.state = .failed
         } else
         */
        if (distance1 != distance0 || dx != 0.0 || dy != 0.0) {
            scale = distance1/distance0
            moved.x = dx
            moved.y = dy
            center = newCentroid
            if (self.state == .possible) {
                self.state = .began
            } else {
                self.state = .changed
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (event.allTouches?.count != 2) {
            self.state = .failed
            return
        }
        
        let first = event.allTouches!.first
        for view in exclusives {
            if (view.isHidden) {
                continue
            }
            let location = first?.location(in: view)
            if (location == nil) {
                continue
            }
            if (location!.x > 0 && location!.y > 0
                && location!.x < view.frame.width && location!.y < view.frame.height) {
                self.state = .failed
                return
            }
        }
        
        super.touchesBegan(touches, with: event)
        previousFirstFinger = nil
        previousSecondFinger = nil
        
        self.state = .possible
        self.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        if (self.state == .possible) {
            self.state = .failed
        } else {
            self.state = .ended
            self.touchesMoved(touches, with: event)
        }
    }
}

