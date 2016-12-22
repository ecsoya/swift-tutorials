//
//  TweetsFactory.swift
//  Twitter
//
//  Created by Ecsoya on 21/12/2016.
//  Copyright © 2016 Ecsoya. All rights reserved.
//

import Foundation

public struct TweetsFactory {
    public static func loadTweets() -> [Array<Twitt>] {
        
        var tweets = [Array<Twitt>]()
        
        let ecsoya = User(name: "Ecsoya", age: 30)
        let url = URL(string: "https://ecsoya.github.io/images/ecsoya.jpg")!
        for i in 0...1000 {
            var twi = Array<Twitt>()
            
            for j in 1...5 {
               twi.append(Twitt(text: "text \(i) \(j)", user: ecsoya, created: NSDate(timeIntervalSinceNow: 2000 * Double(j)), profileImageURL: url))
            }
            
            tweets.append(twi)
        }
        
        return tweets
    }
}
