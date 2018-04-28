//
//  UserService.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/28/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile: User?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile: User?) -> ())) {
        let userRef = Database.database().reference().child("users/\(uid)/profile")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile: User?
            
            if let dict = snapshot.value as? [String: Any],
                let username = dict["username"] as? String,
                let email = dict["email"] as? String {
            userProfile = User(uid: uid, username: username, email: email)
            
            }
            completion(userProfile)
        })
    }
}
