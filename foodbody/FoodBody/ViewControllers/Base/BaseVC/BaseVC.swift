//
//  BaseVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase;

let tagLoading: Int = 999999

class BaseVC: UIViewController {
    
    lazy var loadingView: LoadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isKind(of: ReservationVC.self) || self.isKind(of: ProfileVC.self) || self.isKind(of: VerifyVC.self) {
           //
        }else{
            let backButton = UIButton()
            let image = UIImage(named: "backArow")
            backButton.setImage(image, for: .normal)
            backButton.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
            backButton.frame = CGRect(x: 0, y: 0, width:30, height: 44)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
       
    }
    
    
    @objc func actionBack() {
        // can overide
        self.navigationController?.popViewController(animated: true)
    }
	
	//click to view to hide keyboard
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    public func showLoading(){
        DispatchQueue.main.async {
            self.loadingView.tag = tagLoading
            self.view.addSubview(self.loadingView)
        }
    }
    
    public func hideLoading(){
        DispatchQueue.main.async {
            if let viewWithTag = self.view.viewWithTag(tagLoading) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    func getRestaurantWithProfile() {
        
        self.showLoading()
        
        RequestManager.getRestaurantWithProfile() { (result) in
            
            self.hideLoading()
            
            guard let result = result else { return }
            
            if result.isSuccess {
                
                AppManager.restaurant = result.myRestaurant.first
                AppManager.caculateCaloriesLeft()
            }
        }
        
    }
}
