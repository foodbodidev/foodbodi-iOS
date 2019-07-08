//
//  Style.swift
//  FoodBody
//
//  Created by Phuoc on 6/30/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation


import UIKit

enum Style { // now all style of app should use this stype uniformly
    
    struct Color {
        static let mainGreen = #colorLiteral(red: 0.07058823529, green: 0.7411764706, blue: 0.462745098, alpha: 1)
        static let backgroundTf = #colorLiteral(red: 0.8980392157, green: 0.9294117647, blue: 0.937254902, alpha: 1)
        static let placeHoder = #colorLiteral(red: 0.7254901961, green: 0.7607843137, blue: 0.768627451, alpha: 1)
        static let mainGray = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        
    }
    
    enum FontStyle {
        case regular
        case light
        case bold
        
        func font(with size: CGFloat) -> UIFont {
            switch self {
            case .regular:
                if let temp = UIFont(name: "SFProText-Regular", size: size) {
                    return temp
                }
                return UIFont.boldSystemFont(ofSize: size)
            case .light:
                if let temp = UIFont(name: "SFProText-Light", size: size) {
                    return temp
                }
                return UIFont.boldSystemFont(ofSize: size)
            case .bold:
                if let temp = UIFont(name: "SFProText-Semibold", size: size) {
                    return temp
                }
                return UIFont.boldSystemFont(ofSize: size)
            }
        }
    }

    
}

