//
//  HomeViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/18/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    
    var posts = [Post]()
    var selectedIndexPath: Int!
    
    let presentViewPost = PresentViewPost()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove divider for navigation controller.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.9490196078, blue: 0.8980392157, alpha: 1)
        tableView.separatorStyle = .none
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postCell")
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
        observePosts()
    }
    
    func observePosts() {
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
                    let commentCount = dict["commentCount"] as? Int,
                    let draft = dict["draft"] as? Int
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

                        if draft == 0 {
                            let userProfile = User(uid: uid, username: username, email: email)
                            let post = Post(id: childSnapshot.key, author: userProfile, emoji: emoji, emojiTitle: emojiTitle, header: header, body: body, timestamp: timeText, hugs: String(hugCount), reframes: String(commentCount))
                            tempPosts.append(post)
                        }
                    }
                }
            //Reverse post order!
            self.posts = tempPosts.reversed()
            self.tableView.reloadData()
            })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToPost" {
            let viewController = segue.destination as! ViewPostViewController
            let post = posts[selectedIndexPath]
            viewController.post = post
            
            //let attributes = tableView.
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.selectionStyle = .none
        cell.set(post: posts[indexPath.row])
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "HomeToPost", sender: self)
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentViewPost
    }
}






