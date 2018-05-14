//
//  FirebaseUtils.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/12/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let username = userDictionary["username"] as? String
            let email = userDictionary["email"] as? String
            let user = User(uid: uid, username: username!, email: email!)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
}
