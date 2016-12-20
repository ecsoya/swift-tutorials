//
//  ViewController.swift
//  Cassini
//
//  Created by Ecsoya on 20/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var imageURL: URL? {
        didSet {
            image = nil
            feachImage()
        }
    }
    
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
        }
    }
    
    private func feachImage() {
        if let url = imageURL {
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
                print("Image has been created")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        imageURL = URL(string: DemoURLs.Ecsoya)
    }
    
    
}

