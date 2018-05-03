//
//  ViewPostViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/1/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import Firebase

class ViewPostViewController: UIViewController {

    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var commentCollectionView: UICollectionView!
    
    var post: Post?
    var user: User?
    var indexPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameButton.setTitle(post?.author.username, for: .normal)
        feelingLabel.text = "is feeling " + (post?.emojiTitle.lowercased())! + "."
        emojiLabel.text = post?.emoji
        headerLabel.text = post?.header
        bodyLabel.text = post?.body
        
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        
        //commentCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -65, right: 0)
        
        fetchComments()
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
    
    var comments = [Comment]()
    fileprivate func fetchComments() {
        var comment = Comment(dictionary: dict)
        guard let postID = self.post?.id else {return}
        let commentRef = Database.database().reference().child("comments").child(postID)
        commentRef.observe(.childAdded, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String: Any] else {return}
            
            guard let uid = dict["uid"] as? String else {return}
           
            let userRef = Database.database().reference().child("users/\(uid)/profile")
            userRef.observe(.value, with: { snapshot in
                
                if (snapshot.value as? [String: Any]) != nil {
                    //let snap = snapshot.value as? [String: Any]
                    
                   // comment.user = snapshot.value as? User
                    }
                })
            var comment = Comment(dictionary: dict)
            self.comments.append(comment)
            self.commentCollectionView.reloadData()
            })
    }
    
    lazy var containerView: UIView = {
        
        //Set up the container
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 65)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        self.commentTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        self.commentTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        self.commentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.commentTextField.frame.height)) // adding left padding so it's not sticked to border
        self.commentTextField.leftViewMode = .always
        
        let sendButton = UIButton(type: .system)
        //let sendButton = UIImageView(image: #imageLiteral(resourceName: "arrowUp"))
        containerView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(#colorLiteral(red: 0.2901960784, green: 0.3725490196, blue: 0.937254902, alpha: 1), for: .normal)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        sendButton.addTarget(self, action: #selector(handlePostComment), for: .touchUpInside)
        sendButton.trailingAnchor.constraint(equalTo: self.commentTextField.trailingAnchor, constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: self.commentTextField.centerYAnchor).isActive = true
        self.commentTextField.rightView = sendButton
        self.commentTextField.rightViewMode = .always
        
        let hugButton = UIButton()
        containerView.addSubview(hugButton)
        hugButton.translatesAutoresizingMaskIntoConstraints = false
        hugButton.setTitle("🤗", for: .normal)
        hugButton.backgroundColor = #colorLiteral(red: 0.9784782529, green: 0.9650371671, blue: 0.9372026324, alpha: 1)
        hugButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        hugButton.layer.cornerRadius = 25
        hugButton.layer.masksToBounds = true
        hugButton.leadingAnchor.constraint(equalTo: self.commentTextField.trailingAnchor, constant: 10).isActive = true
        hugButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        hugButton.centerYAnchor.constraint(equalTo: self.commentTextField.centerYAnchor).isActive = true
        
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add a reframe..."
        textField.textAlignment = .left
        textField.backgroundColor = #colorLiteral(red: 0.9784782529, green: 0.9650371671, blue: 0.9372026324, alpha: 1)
        textField.layer.cornerRadius = 50/2
        textField.layer.masksToBounds = true
        textField.borderStyle = .none
        return textField
    }()
    
    @objc func handlePostComment() {
        print(commentTextField)
        let postID = post?.id
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let commentValues: [String: Any] = [
            "comment" : commentTextField.text ?? "",
            "uid": uid,
            "commentDate": Date().timeIntervalSince1970
            ]
        
        Database.database().reference().child("comments").child(postID!).childByAutoId().updateChildValues(commentValues) { error, ref in
            if error == nil {
                print("Successfully added comment")
            }
            else {
                print ("Error: \(error!.localizedDescription)")
            }
        }
}
    
    //Setting up the keyboard accessory view for comments.
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension ViewPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! CommentCollectionViewCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
}
