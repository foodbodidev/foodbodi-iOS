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
        static let darkBlueGreen = #colorLiteral(red: 0, green: 0.4156862745, blue: 0.2352941176, alpha: 1)
        static let backgroundTf = #colorLiteral(red: 0.8980392157, green: 0.9294117647, blue: 0.937254902, alpha: 1)
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

