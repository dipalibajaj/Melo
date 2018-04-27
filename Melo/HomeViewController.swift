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
    
    var posts = [
        Post(id: "1", author: "dipsster is feeling anxious.", emoji: "😢", header: "Note Title.", body: "Such as personal hygiene, brushing, eating, putting on clothing. I'm just going to keep writing to see what happens."),
        Post(id: "2", author: "sander_castle is feeling hopeful.", emoji: "🌸", header: "Note Title", body: "Feeling happy to explore, meet people, try new things."),
        Post(id: "3", author: "tansh is feeling sick.", emoji: "🤢", header: "Note Title.", body: "Nobody really understands me, or am I not saying it properly?"),
        Post(id: "4", author: "jimmy420 is feeling angry.", emoji: "🤬", header: "Note Title", body: "Still can't seem to figure out any of this code. Bloody JS"),
        Post(id: "5", author: "drewbert is feeling crazy.", emoji: "🤪", header: "Note Title", body: "This code is working out. So glad we switched to Swift"),
        Post(id: "6", author: "jkndy is feeling cool.", emoji: "😎", header: "Note Title", body: "We're actually going to make Hang happen. Coming in Fall 2018.")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove divider for navigation controller.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9647058824, blue: 0.9450980392, alpha: 1)
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
        
        //Making sure the last post cell is visible.
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height, 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
