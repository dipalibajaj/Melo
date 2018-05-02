//
//  InputAccessoryView.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/1/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView {

    @IBOutlet weak var hugContainerView: UIView!
    @IBOutlet weak var hugEmojiButton: UIButton!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var accessoryContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
