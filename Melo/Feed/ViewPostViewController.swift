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
    
    let now = Date()
    let pastDate = Date(timeIntervalSinceNow: -10)
    
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

    var comments = [Comment]()
    fileprivate func fetchComments() {
        
        guard let postID = self.post?.id else {return}
        let commentRef = Database.database().reference().child("comments").child(postID)
        commentRef.observe(.childAdded, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String: Any] else {return}
            guard let comment = dict["comment"] as? String else {return}
            guard let uid = dict["uid"] as? String else {return}
            guard let commentDate = dict["commentDate"] as? Double else {return}

            
            let userRef = Database.database().reference().child("users/\(String(describing: uid))/profile")
            userRef.observe(.value, with: { snapshot in
                guard let value = snapshot.value as? [String:Any] else {return}
                let username = value["username"]
                let uid = dict["uid"]
                let email = value["email"]
                
                let timestampDate = Date(timeIntervalSince1970: Double(commentDate))
                let now = Date()
                let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth, .year])
                let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
                
                var timeText = ""
                if diff.second! <= 0 {
                    timeText = "Just now"
                }
                else if diff.second! > 0 && diff.minute! == 0 {
                    timeText = (diff.second == 1) ? "\(diff.second!)s ago" : "\(diff.second!)s ago"
                }
                else if diff.minute! > 0 && diff.hour! == 0 {
                    timeText = (diff.minute == 1) ? "\(diff.minute!)m ago" : "\(diff.minute!)m ago"
                }
                else if diff.hour! > 0 && diff.day! == 0 {
                    timeText = (diff.hour == 1) ? "\(diff.hour!)h ago" : "\(diff.hour!)h ago"
                }
                else if diff.day! > 0 && diff.weekOfMonth! == 0 {
                    timeText = (diff.day == 1) ? "\(diff.day!)d ago" : "\(diff.day!)d ago"
                }
                else if diff.weekOfMonth! > 0 {
                    timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!)w ago" : "\(diff.weekOfMonth!)w ago"
                }
                else if diff.year! > 0 {
                    timeText = (diff.year == 1) ? "\(diff.year!)y ago" : "\(diff.year!)y ago"
                }

                let userProfile = User(uid: uid as! String, username: username as! String, email: email as! String)
                let comment = Comment(uid: uid as! String, user: userProfile, comment: comment, time: timeText)
                self.comments.append(comment)
                self.commentCollectionView.reloadData()
                })
            })
    }
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.backgroundColor = .white
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
                self.commentCounter()
            }
            else {
                print ("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    func commentCounter() {
        guard let postID = post?.id else {return}
        let ref = Database.database().reference().child("posts").child(postID)
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject] {
                var commentCount = post["commentCount"] as? Int ?? 0
                commentCount += 1
                post["commentCount"] = commentCount as AnyObject?
                currentData.value = post
                self.post?.reframes = String(commentCount)
                
                DispatchQueue.main.async {
                    self.commentCollectionView.reloadData()
                }
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        })
    }
    
    func didHug(for cell: CommentInputAccessoryView) {
        guard let postID = self.post?.id else {return}
        
        let ref = Database.database().reference().child("posts").child(postID)
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var hugs: Dictionary<String, Bool>
                hugs = post["hugs"] as? [String : Bool] ?? [:]
                var hugCount = post["hugCount"] as? Int ?? 0
                if let _ = hugs[uid] {
                    // Unhug the post and remove self from hugs
                    hugCount -= 1
                    hugs.removeValue(forKey: uid)
                } else {
                    // Hug the post and add self to hugs
                    hugCount += 1
                    hugs[uid] = true
                }
                post["hugCount"] = hugCount as AnyObject?
                post["hugs"] = hugs as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post

                
                self.post?.hasHugged = !(self.post?.hasHugged)!
                
                DispatchQueue.main.async {
                    if self.post?.hasHugged == true {
                        self.containerView.hugButton.setImage(UIImage (named: "smiley-active-icon"), for: .normal)
                    }
                    else if self.post?.hasHugged == false {
                        self.containerView.hugButton.setImage(UIImage (named: "smiley-icon"), for: .normal)
                    }
                }
                
                self.post?.hugs = String(hugCount)

                DispatchQueue.main.async {
                    self.commentCollectionView.reloadData()
                }
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
            
        })
            {
            (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
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
            let approxWidthOfBodyText = view.frame.width - 22 - 22 - 18
            let size = CGSize(width: approxWidthOfBodyText, height: 1000)
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
            let estimatedFrame = NSString(string: post.body).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            return CGSize(width: view.frame.height, height: estimatedFrame.height + 220)
        }
        return CGSize(width: view.frame.height, height: 200)
    }
}






