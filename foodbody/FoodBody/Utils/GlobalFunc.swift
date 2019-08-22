//
//  BlobalFunc.swift
//  FoodBody
//
//  Created by Phuoc on 6/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import UIKit


let FBAppDelegate = UIApplication.shared.delegate as! AppDelegate
struct defaultsKeys {
    static let kUserlogin = "kUserlogin"
    static let kRestaurant = "kRestaurant"
}
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
extension Notification.Name {
    static let kFb_update_restaurant = Notification.Name("kFb_update_restaurant")
    static let kFb_update_reservation = Notification.Name("kFb_update_reservation")
    
}

extension UITableView {
    
    func showLoadingFooter(){
        let loadingFooter = UIActivityIndicatorView(style: .gray)
        loadingFooter.frame.size.height = 50
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableFooterView = loadingFooter
    }
    
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 50
            }, completion: { finished in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    func isLoadingFooterShowing() -> Bool {
        return tableFooterView is UIActivityIndicatorView
    }
    
}
