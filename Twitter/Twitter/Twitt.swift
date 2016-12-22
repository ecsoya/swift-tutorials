//
//  Twitt.swift
//  Twitter
//
//  Created by Ecsoya on 21/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import Foundation

public class Twitt: NSObject {
    public let text: String
    public let user: User
    public let created: NSDate
    public let profileImageURL: URL
    
    init(text: String, user: User, created: NSDate, profileImageURL: URL) {
        self.text = text
        self.user = user
        self.created = created
        self.profileImageURL = profileImageURL
    }
}
