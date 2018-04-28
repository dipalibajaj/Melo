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
    

    var emojiSection: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Remove divider for navigation controller.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        emojiIconLabel.text = emojiSection["emojiIcon"]
        
        self.hideKeyboardWhenTappedAround()

    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
            "header": headerTextField.text!,
            "body": bodyTextView.text,
            "timestamp": [".sv":"timestamp"]
            ] as [String: Any]
        
        postRef.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
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
