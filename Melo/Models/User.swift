//
//  User.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/25/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation
import Firebase

class User {
    var username: String
    let uid: String
    //var birthday: String
    var email: String
    
    var ref: DatabaseReference!
    
    init(uid: String, username: String, email: String) { //Need to add (birthday: String) to init when added to UI
        self.uid = uid
        self.username = username
        //self.birthday = birthday
        self.email = email
    }
    
    func saveUser() {
        let userRef = Database.database().reference()
        userRef.child("users").child(uid).setValue(toUserDictionary())
    }
    
    func toUserDictionary() -> [String : Any] {
        return [
            "uid" : uid,
            "username" : username,
            //"birthday" : birthday,
            "email" : email
        ]
    }
}
