//
//  Meal.swift
//  FoodTracker
//
//  Created by Ecsoya on 13/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import UIKit

class Meal{
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
}
