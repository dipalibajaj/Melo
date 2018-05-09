//
//  CommentCollectionViewCell.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/3/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2*22)
    }
    
    var comment: Comment? {
        didSet {
            commentLabel.text = comment?.comment
            usernameLabel.text = comment?.user.username
            commentTime.text = comment?.time
        }
    }

}
