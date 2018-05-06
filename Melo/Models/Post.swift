//
//  Post.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/19/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation
import Firebase

class Post {
    var id:String
    var author:User
    var emoji: String
    var emojiTitle: String
    var header:String
    var body:String
    var timestamp: Double
    //var reframes: Int
    
    init(id:String, author:User, emoji:String, emojiTitle: String, header:String, body:String, timestamp:Double) {
        self.id = id
        self.author = author
        self.emoji = emoji
        self.emojiTitle = emojiTitle
        self.header = header
        self.body = body
        self.timestamp = timestamp
        //self.reframes = reframes
    }
 
}
