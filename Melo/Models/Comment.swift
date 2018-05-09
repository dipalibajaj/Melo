//
//  Comment.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/2/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation

class Comment {
    
    var user: User
    var comment: String
    var uid: String
    var time: String
    
    init(uid:String, user:User, comment:String, time:String) {
        self.uid = uid
        self.user = user
        self.comment = comment
        self.time = time
    }
}
