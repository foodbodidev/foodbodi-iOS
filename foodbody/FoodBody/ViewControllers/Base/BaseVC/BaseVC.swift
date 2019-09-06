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
        let db = Firestore.firestore()
        var email = "";
        email = AppManager.user!.email;
        db.collection("notifications").whereField("receiver", isEqualTo: email).whereField("read", isEqualTo: false).addSnapshotListener { (querySnapshot, error) in
            print("receive notifications accept restaurant!")
            let alert = UIAlertController(title:nil, message: "Your restaurant is accepted by Fodimap!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) {
                UIAlertAction in
                //go to company information.
            }
            alert.addAction(action)
            self.appDelegate.window?.rootViewController?.navigationController?.present(alert, animated: false, completion: nil);
        }
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
                
                if let user = AppManager.user {
                    user.restaurantId = result.myRestaurant.first?.id ?? ""
                    AppManager.user = user
                }
                
                AppManager.restaurant = result.myRestaurant.first
            }
        }
        
    }
    
    

}
