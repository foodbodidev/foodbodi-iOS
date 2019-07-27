//
//  InforTextField.swift
//  FoodBody
//
//  Created by Phuoc on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class InforTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        self.backgroundColor = Style.Color.backgroundTf
        self.layer.shadowRadius = 4
        
        var myMutableStringTitle = NSMutableAttributedString()
        myMutableStringTitle = NSMutableAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.font: Style.FontStyle.regular.font(with: 14)]) // Font
        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: Style.Color.placeHoder, range: NSRange(location:0, length: self.placeholder?.count ?? 0))
        self.attributedPlaceholder = myMutableStringTitle
        self.font = Style.FontStyle.regular.font(with: 14)
    
    }
}

