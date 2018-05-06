//
//  ViewPostViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/1/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import Firebase

class ViewPostViewController: UIViewController, CommentInputAccessoryViewDelegate {

    @IBOutlet weak var commentCollectionView: UICollectionView!
    
    var post: Post?
    var user: User?
    var indexPath: String?
    
    
    struct Storyboard {
        static let viewPostHeader = "ViewPostHeaderView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        
        //Registering the commentCell Nib
        commentCollectionView.register(UINib.init(nibName: "CommentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "commentCell")
        commentCollectionView.register(UINib(nibName: "ViewPostCollectionReusableView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        
        //Dynamic comment height.
        if let flowLayout = commentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        commentCollectionView.alwaysBounceVertical = true
        commentCollectionView.keyboardDismissMode = .interactive
        
        fetchComments()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        commentCollectionView.collectionViewLayout.invalidateLayout()
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
        
        guard let postID = self.post?.id else {return}
        let commentRef = Database.database().reference().child("comments").child(postID)
        commentRef.observe(.childAdded, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String: Any] else {return}
            guard let comment = dict["comment"] as? String else {return}
            guard let uid = dict["uid"] as? String else {return}
            
            let userRef = Database.database().reference().child("users/\(String(describing: uid))/profile")
            userRef.observe(.value, with: { snapshot in
                guard let value = snapshot.value as? [String:Any] else {return}
                let username = value["username"]
                let uid = dict["uid"]
                let email = value["email"]
                let userProfile = User(uid: uid as! String, username: username as! String, email: email as! String)
                let comment = Comment(uid: uid as! String, user: userProfile, comment: comment)
                self.comments.append(comment)
                self.commentCollectionView.reloadData()
                })
            })
    }
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    func didSend(for comment: String) {
        let postID = post?.id
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let commentValues: [String: Any] = [
            "comment" : comment,
            "uid": uid,
            "commentDate": Date().timeIntervalSince1970
        ]
        
        Database.database().reference().child("comments").child(postID!).childByAutoId().updateChildValues(commentValues) { error, ref in
            if error == nil {
                self.containerView.clearCommentTextView()
                self.containerView.clearKeyboard()
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

extension ViewPostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! CommentCollectionViewCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! ViewPostCollectionReusableView
        let currentPost = self.post
        headerView.post = currentPost
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let post = self.post {
            let approxWidthOfBodyText = view.frame.width - 22 - 22 - 22
            let size = CGSize(width: approxWidthOfBodyText, height: 1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
            let estimatedFrame = NSString(string: post.body).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            return CGSize(width: view.frame.height, height: estimatedFrame.height + 218)
        }
        return CGSize(width: view.frame.height, height: 200)
    }
}
