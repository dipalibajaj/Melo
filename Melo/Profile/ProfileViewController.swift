//
//  ProfileViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/20/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var post: Post?
    var user: User?
    
    var posts = [Post]()
    var selectedIndexPath: Int!
    
    struct Storyboard {
        static let viewPostHeader = "ProfileHeaderView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        //Setting username to current user.
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userRef = Database.database().reference().child("users/\(uid)/profile")
        userRef.observe(.value, with: { snapshot in
            
            if let dict = snapshot.value as? [String: Any] {
                let username = dict["username"] as? String
                self.navigationItem.title = (username)!
            }
        })
        
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
    profileCollectionView.register(UINib.init(nibName: "PostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "postCollectionCell")
       profileCollectionView.register(UINib(nibName: "ProfileCollectionReusableView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "profileHeader")
        
        observePosts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileCollectionView.collectionViewLayout.invalidateLayout()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func observePosts() {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let postRef = Database.database().reference().child("posts")
        postRef.observe(.value, with: { snapshot in
            
            var tempPosts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let email = author["email"] as? String,
                    let username = author["username"] as? String,
                    let header = dict["header"] as? String,
                    let body = dict["body"] as? String,
                    let emoji = dict["emoji"] as? String,
                    let emojiTitle = dict["emojiTitle"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let hugCount = dict["hugCount"] as? Int,
                    let commentCount = dict["commentCount"] as? Int
                {
                    //print(hugCount)
                    //Setting up the time.
                    let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
                    let now = Date()
                    let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth, .month, .year])
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
                    else if diff.month! > 0 {
                        timeText = (diff.month == 1) ? "\(diff.month!)w ago" : "\(diff.month!)w ago"
                    }
                    else if diff.year! > 0 {
                        timeText = (diff.year == 1) ? "\(diff.year!)y ago" : "\(diff.year!)y ago"
                    }
                    if currentUID == uid {
                        let userProfile = User(uid: uid, username: username, email: email)
                        let post = Post(id: childSnapshot.key, author: userProfile, emoji: emoji, emojiTitle: emojiTitle, header: header, body: body, timestamp: timeText, hugs: String(hugCount), reframes: String(commentCount))
                        tempPosts.append(post)
                    }
                }
            }
            //Reverse post order!
            self.posts = tempPosts.reversed()
            self.profileCollectionView.reloadData()
        })
        
        
    }
    
    @IBAction func handleLogout(_ target: UIBarButtonItem) {
        //Log out user.
        try! Auth.auth().signOut()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileToPost" {
            let viewController = segue.destination as! ViewPostViewController
            let post = posts[selectedIndexPath]
            viewController.post = post
            
            //let attributes = tableView.
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionViewCell
        cell.set(post: posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        profileCollectionView.deselectItem(at: indexPath, animated: true)
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "ProfileToPost", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeader", for: indexPath) as! ProfileCollectionReusableView
        let currentUser = self.user
        headerView.user = currentUser
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 375, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}



