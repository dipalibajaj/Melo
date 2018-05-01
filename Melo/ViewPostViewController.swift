//
//  ViewPostViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/30/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class ViewPostViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    var post: Post?
    var indexPath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = post?.header
        bodyLabel.text = post?.body
        //feelingLabel.text = "is feeling " + (post?.emojiTitle.lowercased())! + "."
        //emojiLabel.text = post["emoji"]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func usernameTapped(_ sender: Any) {
    }
    

}
