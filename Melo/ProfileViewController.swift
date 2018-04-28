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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLogout(_ target: UIBarButtonItem) {
        //Log out user.
        try! Auth.auth().signOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
