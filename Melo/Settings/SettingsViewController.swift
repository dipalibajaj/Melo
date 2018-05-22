//
//  SettingsViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/16/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var logoutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationItem.title = "Settings"
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        let setting = settings[indexPath.row]
        cell.selectionStyle = .none
        cell.settingsLabel.text = setting["settingsTitle"]
        return cell
    }
}
