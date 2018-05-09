//
//  HelperExtensions.swift
//  Melo
//
//  Created by Dipali Bajaj on 4/20/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /**
     Adds a vertical gradient layer with two ~UIColors~ to the ~UIView~.
     - Parameter topColor: The top ~UIColor~.
     - Parameter bottomColor: The bottom ~UIColor~.
     */
    
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

//Function to add character spacing.
extension UILabel {
    func addCharacterSpacing() {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: 0.2, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
