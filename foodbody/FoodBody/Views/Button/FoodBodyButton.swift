//
//  FoodBodyButton.swift
//  FoodBody
//
//  Created by Phuoc on 6/22/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

@IBDesignable
class FoodBodyButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        self.backgroundColor = UIColor(red: 18, green: 189, blue: 118)
        self.setTitleColor(.white, for: .normal)
        self.layer.shadowColor =  UIColor(red: 18, green: 189, blue: 118).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
    }
    
    @IBInspectable var radius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        
        get {
            return self.layer.cornerRadius
        }
        
    }
    
}


