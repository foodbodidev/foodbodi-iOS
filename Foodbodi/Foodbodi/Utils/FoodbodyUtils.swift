//
//  FoodbodyUtils.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

class FoodbodyUtils: NSObject {
    static let shared = FoodbodyUtils();
    private override init(){};
//    func getViewController(className: String, storyboard:String)-> UIViewController {
//        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier:className)
//        return controller;
//    }
//    func getScreenWidth() -> CGFloat{
//        return UIScreen.main.bounds.size.width;
//    }
//    func getScreenHeight() -> CGFloat{
//        return UIScreen.main.bounds.size.height;
//    }
    //Color.
    func RGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
