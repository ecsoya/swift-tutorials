//
//  DemoURLs.swift
//  Cassini
//
//  Created by Ecsoya on 20/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import Foundation

struct DemoURLs {
    static let Ecsoya = "https://ecsoya.github.io/images/2015-07-20-qhl_1.jpg"
    
    static let NSNA = [
        "Cassini" : "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
        "Earth" : "http://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
        "Saturn" : "http://www.nasa.gov/sites/default/files/saturn_collage.jpg"
    ]
    
    static func NASAImageNamed(imageName: String?)  -> URL? {
        if let urlString = NSNA[imageName ?? ""] {
            return URL(string: urlString)
        }
        return nil
    }
}
