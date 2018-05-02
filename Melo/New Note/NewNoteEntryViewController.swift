//
//  NewNoteEntryViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/27/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class NewNoteEntryViewController: UIViewController {

    @IBOutlet weak var emojiIconLabel: UILabel!
    @IBOutlet weak var headerTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var postTimeLabel: UILabel!
    
    var emojiTitleLabel = String()
    var emojiSection: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Remove divider for navigation controller.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        //Setting username to current user.
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userRef = Database.database().reference().child("users/\(uid)/profile")
        userRef.observe(.value, with: { snapshot in
        
            if let dict = snapshot.value as? [String: Any] {
                self.navigationItem.title = dict["username"] as? String
            }
        })
        
        emojiIconLabel.text = emojiSection["emojiIcon"]
        emojiTitleLabel = emojiSection["emojiTitle"]!
        
        self.hideKeyboardWhenTappedAround()

    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
            //Show Home
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toHome = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            self.present(toHome, animated: true, completion: nil)
    }
    

    @IBAction func handleSharePost(_ sender: Any) {
        
        guard let userProfile = UserService.currentUserProfile else { return }
        
        let postRef = Database.database().reference().child("posts").childByAutoId()
        
        let postObject = [
            "author": [
                "uid": userProfile.uid,
                "username": userProfile.username,
                "email": userProfile.email
            ],
            "emoji": emojiIconLabel.text!,
            "emojiTitle": emojiTitleLabel,
            "header": headerTextField.text!,
            "body": bodyTextView.text,
            "timestamp": [".sv":"timestamp"]
            ] as [String: Any]
        
        postRef.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let toHome = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                self.present(toHome, animated: true, completion: nil)
            } else {
                //Handle the error
            }
        })
    }
 
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// Dismiss keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
