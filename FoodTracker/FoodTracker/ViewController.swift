//
//  ViewController.swift
//  FoodTracker
//
//  Created by Ecsoya on 13/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //MARK: Properties
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var mealNameText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mealNameText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:Button actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        defaultLabel.text = "Hello Default 👍"
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        defaultLabel.text = mealNameText.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        mealNameText.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

