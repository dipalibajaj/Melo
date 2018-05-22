//
//  MeloSessionsViewController.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/22/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit
import AVKit

class MeloSessionsViewController: UIViewController {

    @IBOutlet weak var meloSessionsCollectionView: UICollectionView!
    
    var selectedIndexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meloSessionsCollectionView.delegate = self
        meloSessionsCollectionView.dataSource = self
    }
}

extension MeloSessionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meloSessions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "meloSessionsCell", for: indexPath) as! MeloSessionsCollectionViewCell
        let meloSession = meloSessions[indexPath.row]
        cell.sessionTitle.text = meloSession["sessionTitle"]
        cell.sessionImage.image = UIImage(named: meloSession["sessionImage"]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meloSession = meloSessions[indexPath.row]
        let urlString = meloSession["sessionVideo"]
        let url = URL(string: urlString!)
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}
