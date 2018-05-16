//
//  ProfileCollectionReusableView.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/14/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class ProfileCollectionReusableView: UICollectionReusableView {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var user: User? {
        didSet {
            //Set something
        }
    }
}
