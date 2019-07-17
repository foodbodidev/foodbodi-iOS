//
//  UIImageView.swift
//  FoodBody
//
//  Created by Vuong Toan Chung on 7/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit

@IBDesignable
extension UIImageView {
	
	override open func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBInspectable var radius: CGFloat {
		set {
			self.layer.cornerRadius = newValue
		}
		
		get {
			return self.layer.cornerRadius
		}
		
	}
	
}
