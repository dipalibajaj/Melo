//
//  ViewPostViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/1/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class ViewPostViewController: UIViewController {

    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    //var AccessoryView : UIView!
    var post: Post?
    var indexPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameButton.setTitle(post?.author.username, for: .normal)
        feelingLabel.text = "is feeling " + (post?.emojiTitle.lowercased())! + "."
        emojiLabel.text = post?.emoji
        headerLabel.text = post?.header
        bodyLabel.text = post?.body
        
    }

    @IBAction func usernameButtonTapped(_ sender: Any) {
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var inputAccessoryView: UIView? {
        get {
            //Set up the container
            let containerView = UIView()
            containerView.backgroundColor = .clear
            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
            
            let textField = UITextField()
            containerView.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "Add a reframe..."
            textField.textAlignment = .left
            textField.backgroundColor = #colorLiteral(red: 0.9784782529, green: 0.9650371671, blue: 0.9372026324, alpha: 1)
            textField.layer.cornerRadius = 50/2
            textField.layer.masksToBounds = true
            textField.borderStyle = .none
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height)) // adding left padding so it's not sticked to border
            textField.leftViewMode = .always
            
            let sendButton = UIButton()
            //let arrow = UIImageView(image: #imageLiteral(resourceName: "arrowUp"))
            containerView.addSubview(sendButton)
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            sendButton.setTitle("Send", for: .normal)
            sendButton.setTitleColor(.blue, for: .normal)
            sendButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -10).isActive = true
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
         
            let hugButton = UIButton()
            containerView.addSubview(hugButton)
            hugButton.translatesAutoresizingMaskIntoConstraints = false
            hugButton.setTitle("🤗", for: .normal)
            hugButton.backgroundColor = #colorLiteral(red: 0.9784782529, green: 0.9650371671, blue: 0.9372026324, alpha: 1)
            hugButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            hugButton.layer.cornerRadius = 20
            hugButton.layer.masksToBounds = true
            hugButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10).isActive = true
            hugButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
            hugButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
            
            // Negative values for constraints can be avoided if we change order of views when applying constrains
            // f.e. instead of button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
            // write containerView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8).isActive = true
            
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}
