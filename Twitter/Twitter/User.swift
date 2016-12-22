//
//  User.swift
//  Twitter
//
//  Created by Ecsoya on 21/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import Foundation

public class User {
    public let name: String
    public let age: UInt8
    
    init(name: String, age: UInt8) {
        self.age = age
        self.name = name
    }
}
