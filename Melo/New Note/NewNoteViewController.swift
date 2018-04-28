//
//  NewNoteViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/27/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {

    @IBOutlet weak var emojiCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewNoteToEntry" {
            let destViewController = segue.destination as! UINavigationController
            let toViewController = destViewController.topViewController as! NewNoteEntryViewController
            let indexPath = sender as! IndexPath
            let emojiSection = emojiSections[indexPath.row]
            toViewController.emojiSection = emojiSection
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NewNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiSectionCell", for: indexPath) as! EmojiCollectionViewCell
        let emojiSection = emojiSections[indexPath.row]
        cell.emojiIconLabel.text = emojiSection["emojiIcon"]
        cell.emojiTitleLabel.text = emojiSection["emojiTitle"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NewNoteToEntry", sender: indexPath)
    }
}
