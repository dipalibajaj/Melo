//
//  LearnViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/25/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import AVKit

class LearnViewController: UIViewController {
    
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBAction func playButtonTapped(_ sender: Any) {
        let urlString = "https://player.vimeo.com/external/235468301.hd.mp4?s=e852004d6a46ce569fcf6ef02a7d291ea581358e&profile_id=175"
        let url = URL(string: urlString)
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    var selectedIndexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Remove divider for navigation controller.
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LearnViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gettingStarted.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "introCardCell", for: indexPath) as! GettingStartedCollectionViewCell
        let intro = gettingStarted[indexPath.row]
        cell.introTitleLabel.text = intro["introTitle"]
        cell.introImageLabel.image = UIImage(named: intro["introImage"]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "toAudioPlayer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAudioPlayer" {
            let playerViewController = segue.destination as! AudioPlayerViewController
            let introLesson = gettingStarted[selectedIndexPath]
            playerViewController.introLesson = introLesson
            playerViewController.tag = 1
        }
    }
}

