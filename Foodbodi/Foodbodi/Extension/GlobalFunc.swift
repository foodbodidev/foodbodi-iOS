//
//  BlobalFunc.swift
//  FoodBody
//
//  Created by Phuoc on 6/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import UIKit

func Log(_ s: CustomStringConvertible, file: String = #file, line: Int = #line) {
    #if DEBUG
    let fileName = file.components(separatedBy: "/").last!
    let df = DateFormatter()
    df.dateFormat = "HH:mm:ss"
    let date = df.string(from: Date())
    print("[\(date) \(fileName) L\(line)] \(s)")
    #endif
}


func getStatusBarHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.height
}

func getBottomPaddingiPhoneX() -> CGFloat {
    if isiPhoneX() {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return (window?.safeAreaInsets.bottom)!
        }
    }
    return 0.0
}

func isiPhoneX() -> Bool {
    if UIApplication.shared.statusBarFrame.height >= CGFloat(44) {
        return true
    }
    return false
}
func getViewController(className: String, storyboard:String)-> UIViewController {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier:className)
    return controller;
}
func getScreenWidth() -> CGFloat{
    return UIScreen.main.bounds.size.width;
}
func getScreenHeight() -> CGFloat{
    return UIScreen.main.bounds.size.height;
}
