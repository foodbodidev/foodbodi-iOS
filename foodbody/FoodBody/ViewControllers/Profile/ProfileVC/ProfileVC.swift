//
//  ProfileVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/17/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import Charts
import HealthKit


class ProfileVC: BaseVC {
    
    @IBOutlet weak var stepView: UIView!
	@IBOutlet weak var stepLabel: UILabel!
	@IBOutlet var chartView: PieChartView!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var caloLabel: UILabel!
	
	var rateDataSource: [Int] =  [70, 30]
	
	var totalCalo: Double = 3000 // by fefault
    
    let dailyLogModel: DailyLogModel = DailyLogModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
		setupChart()
        fetchData()
       
    }
    
    @IBAction func actionLogout() {
        FBAppDelegate.gotoWelcome()
        AppManager.user = nil
    }
	
	@IBAction func actionCalendar() {
		let calendarVC = CalendarVC.init(nibName: "CalendarVC", bundle: nil)
		calendarVC.modalPresentationStyle = .overFullScreen
		calendarVC.modalTransitionStyle = .crossDissolve
		calendarVC.delegate = self
		self.present(calendarVC, animated: true, completion: nil)
	}
	
	@IBAction func actionFillCalor() {
		Log(#function)
	}
	
    private func setupLayout() {
       stepView.layer.borderColor = Style.Color.showDowColor.cgColor
       stepView.layer.borderWidth = 1
	   dateLabel.text = "Today, \(Date().toString())"
    }
    
    
	private func setupChart() {
	
		let l = chartView.legend
		l.horizontalAlignment = .right
		l.verticalAlignment = .top
		l.orientation = .vertical
		l.xEntrySpace = 7
		l.yEntrySpace = 0
		l.yOffset = 0
		
		chartView.entryLabelColor = .white
		chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
		chartView.usePercentValuesEnabled = false
		chartView.drawSlicesUnderHoleEnabled = false
		chartView.holeRadiusPercent = 0.8//0.58
		chartView.transparentCircleRadiusPercent = 0.61
		chartView.chartDescription?.enabled = false
		chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
		chartView.drawCenterTextEnabled = true
		chartView.centerText = ""
		chartView.drawHoleEnabled = true
		chartView.rotationAngle = 0
		chartView.rotationEnabled = false
		chartView.highlightPerTapEnabled = false
		
		let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.alignment = .center
		
		chartView.animate(xAxisDuration: 0.4, easingOption: .easeInCirc)
		self.updateChartData()
	}
	
	func updateChartData() {
		self.setDataCount(Int(2), range: 100)
	}
	
	func setDataCount(_ count: Int, range: UInt32) {
		let entries = (0..<count).map { (i) -> PieChartDataEntry in
			// IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
			return PieChartDataEntry(value: Double(rateDataSource[i]),
									 label: "",
									 icon: nil)
		}
		
		let set = PieChartDataSet(entries: entries, label: "Results")
		set.drawIconsEnabled = false
		set.sliceSpace = 0
		
		set.setColor(Style.Color.backgroundTf)
		set.addColor(Style.Color.mainGreen)
		
		let data = PieChartData(dataSet: set)
		
//		let pFormatter = NumberFormatter()
//		pFormatter.numberStyle = .percent
//		pFormatter.maximumFractionDigits = 0
//		pFormatter.percentSymbol = "%"
//		data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
		
		data.setValueFont(.systemFont(ofSize: 11, weight: .light))
		data.setValueTextColor(.black)
		
		chartView.data = data
		chartView.highlightValues(nil)
	}
    
    func fetchData() {
		let yesterday = Date().dayBefore
		let today = Date(timeInterval: 86400, since: yesterday)
		getSteps(dateQuery: today) // get data of today
		getCaloriesConsumed(dateQuery: today)
    }
	
	func getSteps(dateQuery: Date) {
		HealthKitManager.shared.getSteps(dateQuery: dateQuery, completion: { step in
			DispatchQueue.main.async {
				self.bindData(steps: step)
			}
		})
	}
	
	func getCaloriesConsumed(dateQuery: Date) {
		HealthKitManager.shared.getCaloriesConsumed(dateQuery: Date(), completion: { calors in
			
		})
	}
	
	func bindData(steps: Int) {
		let caloLeft = caculateCaloriesLeft(steps: steps)
		let caloLeftRate = Double(caloLeft)!/totalCalo*100
		
		self.stepLabel.text = "\(Int(steps)) Steps"
		self.caloLabel.text = caloLeft
		self.dailyLogModel.step = steps
		self.updateDailyLog()
		self.rateDataSource = [Int(caloLeftRate), 100 - Int(caloLeftRate)]
		self.updateChartData()
		print(steps)
	}
    
    func updateDailyLog() {
        
        dailyLogModel.date = Date().yyyyMMdd
        RequestManager.updateDailyLog(dailyLog: dailyLogModel) { (_, _) in
            
        }
    }
	
	private func caculateCaloriesLeft(steps: Int) -> String {
		let duration = Double(steps)/1.38/60 // minutes
		let calorLeft = totalCalo - Double((AppManager.user?.weight) ?? 50)*0.088*duration // default 3000 calor in a day
		return NSString(format:"%.0f", calorLeft) as String
	}
}

extension ProfileVC: CalendarVCDelegate {
	func didSelectDate(date: Date) {
		dateLabel.text = date.toString()
		getSteps(dateQuery: date)
		self.dismiss(animated: true, completion: nil)
	}
}


