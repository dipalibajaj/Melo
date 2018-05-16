//
//  PostCollectionViewCell.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/14/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postCardView: UIView!
    @IBOutlet weak var reframeCount: UILabel!
    @IBOutlet weak var hugCount: UILabel!
    @IBOutlet weak var reframeLabel: UILabel!
    @IBOutlet weak var hugLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(post:Post) {
        usernameLabel.text = (post.author.username) + " is feeling " + (post.emojiTitle.lowercased()) + "."
        feelingLabel.text = post.emoji
        headerLabel.text = post.header
        bodyLabel.text = post.body
        timeLabel.text = post.timestamp
        
        hugLabel.text = "HUGS"
        hugLabel.addCharacterSpacing()
        hugCount.text = String(post.hugs)
        
        reframeLabel.text = "REFRAMES"
        reframeLabel.addCharacterSpacing()
        reframeCount.text = String(post.reframes)
    }

}
