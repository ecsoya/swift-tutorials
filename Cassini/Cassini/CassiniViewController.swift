//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Ecsoya on 21/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController, UISplitViewControllerDelegate {
    
    private struct Storyboard {
        static let ShowImageIdentifier = "Show Image"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowImageIdentifier {
            if let imageCV = segue.destination.contentViewController as? ImageViewController {
                let imageName = (sender as? UIButton)?.currentTitle
                let url = DemoURLs.NASAImageNamed(imageName: imageName)
                imageCV.imageURL = url
                imageCV.title = imageName
            }
        }
    }
    
    @IBAction func showImage(_ sender: UIButton) {
        //For iPad, the details page is always displayed, we need to update when the button is clicked.
        if let imageCV = splitViewController?.viewControllers.last?.contentViewController as? ImageViewController {
            let imageName = sender.currentTitle
            let url = DemoURLs.NASAImageNamed(imageName: imageName)
            imageCV.imageURL = url
            imageCV.title = imageName
        } else {
            // But for the iPhones, the details page will displayed with Segue when we call it.
            // The Segue will be created when to show it every times.
            // To perform Segue, we need to ctr-drag the whole master view to details view to create segue, not for each buttons.
            performSegue(withIdentifier: Storyboard.ShowImageIdentifier, sender: sender)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contentViewController == self {
            if let ivc = secondaryViewController.contentViewController as? ImageViewController, ivc.imageURL == nil {
                return true // If the imageURL of detail page is not set, we just display the master page
            }
        }
        return false
    }
    
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let nav = self as? UINavigationController {
            return nav.visibleViewController ?? self
        }else {
            return self
        }
    }
}
