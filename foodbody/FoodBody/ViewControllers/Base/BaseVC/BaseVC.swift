//
//  BaseVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/18/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

let tagLoading: Int = 999999

class BaseVC: UIViewController {
    
    lazy var loadingView: LoadingView = LoadingView(frame: CGRect(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
		setupNavigationBarItem()
        self.edgesForExtendedLayout = UIRectEdge.init()
		

    }
	
	//click to view to hide keyboard
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
	}
	
	private func setupNavigationBarItem() {
		let backButton = UIButton()
		let image = UIImage(named: "backArow")?.withRenderingMode(.alwaysTemplate)
		backButton.setImage(image, for: .normal)
		backButton.tintColor = Style.Color.mainPurple
		backButton.addTarget(self, action: #selector(actionBack), for: .touchUpInside)
		backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")// hide line of nav
	}
	
	@objc func actionBack() {
		self.navigationController?.popViewController(animated: true)
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
