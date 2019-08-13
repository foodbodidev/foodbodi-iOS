//
//  CalendarVC.swift
//  FoodBody
//
//  Created by Vuong Toan Chung on 8/13/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar


protocol CalendarVCDelegate: class {
	func didSelectDate(date: Date)
}

class CalendarVC: BaseVC {
	
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var okButton: UIButton!
	@IBOutlet weak var dateContent: FSCalendar!
	
	var dateSelected: Date = Date()
	weak var delegate: CalendarVCDelegate?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dateContent.delegate = self
		configureLayout()
	}
	
	fileprivate func configureLayout() {
	}
	
	
	@IBAction func actionOk() {
		if let delegate = self.delegate {
			delegate.didSelectDate(date: dateSelected)
		}
	}
	
	@IBAction func actionDismiss() {
		self.dismiss(animated: true, completion: nil)
	}
	
}

extension CalendarVC: FSCalendarDelegate {
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		dateSelected = date
	}
}

