//
//  LearnViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/25/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Remove divider for navigation controller.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
