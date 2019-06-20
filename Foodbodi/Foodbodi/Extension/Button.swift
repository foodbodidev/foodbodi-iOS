//
//  Button.swift
//  NEO
//
//  Created by Dev on 3/26/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

extension UIButton {
    
    func underline() {
        guard let text = self.titleLabel?.text else {
            return
        }
        
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributeString, for: .normal)
    }
}

extension UILabel {
    func underline() {
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: self.text ?? "", attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
    }
    
}
