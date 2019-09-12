//
//  BaseLogin.swift
//  FoodBody
//
//  Created by Vuong Toan Chung on 7/19/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import UIKit

class BaseLoginVC: BaseVC {
	

	public func getUserProfile() {
		self.showLoading()
		
		RequestManager.getProfile() { (result, error) in
			
			self.hideLoading()
			if let error = error {
				self.alertMessage(message: error.localizedDescription)
			}
			
			guard let result = result else { return }
			
			if result.isSuccess {
                
                result.token = AppManager.user?.token ?? ""
                AppManager.user = result
            
                
				if self.shouldUpdateProfile(user: result) {
            
					// this means user dose not update user detail
					let selectGenderVC = getViewController(className: SelectGenderVC.className, storyboard: FbConstants.AuthenticationSB)
				NotificationCenter.default.post(name:.kFB_notifi_registerRestaurant, object: nil, userInfo:nil);	self.navigationController?.pushViewController(selectGenderVC, animated: true)
				} else {
					FBAppDelegate.gotoMainTab()
				}
			} else {
				self.alertMessage(message: result.message)
			}
		}
	}
    
    
    
	
	private func shouldUpdateProfile(user: User) -> Bool {
		return user.height == 0
	}
}
