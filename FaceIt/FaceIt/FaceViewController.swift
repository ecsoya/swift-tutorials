//
//  ViewController.swift
//  FaceIt
//
//  Created by Ecsoya on 16/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.pinchZoom)))
        }
    }

}

