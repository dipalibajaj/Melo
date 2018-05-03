//
//  Comment.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/2/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation

struct Comment {
    
    var user: User?
    
    let comment: String
    
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.comment = dictionary["comment"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
