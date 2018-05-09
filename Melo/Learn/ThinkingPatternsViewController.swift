//
//  ThinkingPatternsViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/6/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class ThinkingPatternsViewController: UIViewController {

    @IBOutlet weak var ThinkingPatternsCollectionView: UICollectionView!
    
    var selectedIndexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThinkingPatternsCollectionView.delegate = self
        ThinkingPatternsCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ThinkingPatternsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thinkingPatterns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thinkingPatternsCell", for: indexPath) as! ThinkingPatternsCollectionViewCell
        let thinkingPattern = thinkingPatterns[indexPath.row]
        cell.thinkingPatternTitle.text = thinkingPattern["thinkingPatternTitle"] 
        cell.thinkingPatternImage.image = UIImage(named: thinkingPattern["thinkingPatternImage"]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "thinkToAudioPlayer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "thinkToAudioPlayer" {
            let playerViewController = segue.destination as! AudioPlayerViewController
            let thinkingPatternLesson = thinkingPatterns[selectedIndexPath]
            playerViewController.thinkingPatternsLesson = thinkingPatternLesson
            playerViewController.tag = 2
        }
    }
}
