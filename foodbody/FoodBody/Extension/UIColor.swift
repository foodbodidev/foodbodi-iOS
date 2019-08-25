//
//  UIColor.swift
//  NEO
//
//  Created by Phuoc on 3/23/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    class func backgroundGray() -> UIColor {
        return #colorLiteral(red: 0.9647058824, green: 0.968627451, blue: 0.9725490196, alpha: 1)
    }
    
    class func lightGray() -> UIColor {
        return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
    }
    
    class func darkGray() -> UIColor {
        return #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    }
    class func navColor() ->UIColor{
        return UIColor.init(rgb: 0x1ABC9C);
    }
}
