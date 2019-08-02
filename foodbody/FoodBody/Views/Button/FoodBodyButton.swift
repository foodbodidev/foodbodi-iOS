//
//  FoodBodyButton.swift
//  FoodBody
//
//  Created by Phuoc on 6/22/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class FoodBodyButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        self.backgroundColor = Style.Color.mainGreen
        self.setTitleColor(.white, for: .normal)
        self.layer.shadowColor =  Style.Color.mainGreen.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
    }
    
}


