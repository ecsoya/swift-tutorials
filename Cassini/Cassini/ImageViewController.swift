//
//  ViewController.swift
//  Cassini
//
//  Created by Ecsoya on 20/12/2016.
//  Copyright © 2016 Ecsoya. All   reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate{
    
    var imageURL: URL? {
        didSet {
            image = nil
            //Do it after view has been displayed
            if view.window != nil {
                feachImage()
            }
            
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
            spinner?.stopAnimating()
        }
    }
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            
            //MARKS: Zooming variables
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 2.0
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func feachImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = data {
                            self.image = UIImage(data: imageData)
                        } else {
                            self.spinner?.stopAnimating()
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        //imageURL = URL(string: DemoURLs.Ecsoya)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (image == nil && imageURL != nil) {
            feachImage()
        }
    }
}

