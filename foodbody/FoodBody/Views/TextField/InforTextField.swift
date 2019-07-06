//
//  InforTextField.swift
//  FoodBody
//
//  Created by Phuoc on 7/4/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

@IBDesignable
class InforTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        self.backgroundColor = Style.Color.backgroundTf
        self.layer.shadowRadius = 4
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

