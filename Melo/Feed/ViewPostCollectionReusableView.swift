//
//  ViewPostCollectionReusableView.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/6/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class ViewPostCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.sizeToFit()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2*22)
    }
    
    var post: Post? {
        didSet {
            usernameLabel.text = post?.author.username
            feelingLabel.text = "is feeling " + (post?.emojiTitle.lowercased())! + "."
            emojiLabel.text = post?.emoji
            headerLabel.text = post?.header 
            bodyLabel.text = post?.body
        }
    }
    
}
