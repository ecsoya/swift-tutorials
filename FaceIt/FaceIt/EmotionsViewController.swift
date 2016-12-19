//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Ecsoya on 19/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    // MARK: - Navigation

    private let expressions = ["angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
                               "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
                               "worried": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Smirk),
                               "mischievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)]
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let faceViewController = segue.destination as? FaceViewController
        if faceViewController != nil {
        
            if let identifier = segue.identifier {
                if let newExpression = expressions[identifier] {
                    faceViewController!.expression = newExpression
                }
            }
        }
    }
 

}
