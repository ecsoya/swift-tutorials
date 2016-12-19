//
//  ViewController.swift
//  FaceIt
//
//  Created by Ecsoya on 16/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.pinchZoom)))
            updateUI()
        }
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0]
    private var eyeBrowTitls = [FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0]
    
    private func updateUI() {
        if faceView != nil {
            
            switch expression.eyes {
            case .Open:
                faceView.eyeOpen = true
            default:
                faceView.eyeOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTitls[expression.eyeBrows] ?? 0.0
            
        }
    }
}

