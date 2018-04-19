//
//  Post.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/19/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation

class Post {
    var id:String
    var author:String
    var emoji: String
    var header:String
    var body:String
    
    init(id:String, author:String, emoji:String, header:String, body:String) {
        self.id = id
        self.author = author
        self.emoji = emoji
        self.header = header
        self.body = body
    }
}
