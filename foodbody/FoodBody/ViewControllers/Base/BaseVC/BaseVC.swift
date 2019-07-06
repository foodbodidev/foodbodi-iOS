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

}
