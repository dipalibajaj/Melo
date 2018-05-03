//
//  CommentCollectionViewCell.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/2/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timePostedLabel: UILabel!
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else {return}
            guard let username = comment.user?.username else {return}
            print(username)
            commentLabel.text = comment.comment
            usernameLabel.text = comment.user?.username
        }
    }
}
