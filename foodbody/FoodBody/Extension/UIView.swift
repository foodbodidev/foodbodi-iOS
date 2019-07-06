//
//  UIView.swift
//  NEO
//
//  Created by Phuoc on 3/30/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit


extension UIView {
    
    func addShadowforview() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8
    }
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 0.1]
       // gradientLayer.colors = define colors here
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addSmallGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 0.03]
         // gradientLayer.colors = define colors here
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
