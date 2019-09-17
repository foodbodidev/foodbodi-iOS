//
//  UIFont.swift
//  FoodBody
//
//  Created by Phuoc on 6/22/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func sfProTextRegular(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "SFProText-Regular", size: size)
        if let temp = font {
            return temp
        }
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    static func sfProTextLight(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "SFProText-Light", size: size)
        if let temp = font {
            return temp
        }
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    static func sfProTextSemibold(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "SFProText-Semibold", size: size)
        if let temp = font {
            return temp
        }
        return UIFont.boldSystemFont(ofSize: size)
    }
    
   
    
    
}
