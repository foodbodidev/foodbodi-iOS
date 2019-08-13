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
	
	var rateDataSource: [Int] =  [70, 30]
    
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
		chartView.centerText = "500Kcal";
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
		
		let pFormatter = NumberFormatter()
		pFormatter.numberStyle = .percent
		pFormatter.maximumFractionDigits = 1
		pFormatter.multiplier = 10
		pFormatter.percentSymbol = " %"
		data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
		
		data.setValueFont(.systemFont(ofSize: 11, weight: .light))
		data.setValueTextColor(.black)
		
		chartView.data = data
		chartView.highlightValues(nil)
	}
    
    func fetchData() {
        HealthKitManager.shared.getTodaysSteps(completion: { step in
			self.stepLabel.text = "\(step)"
            self.dailyLogModel.step = step
            self.updateDailyLog()
            print(step)
            
        })
        
        HealthKitManager.shared.getCaloriesConsumed(completion: { calo in
            self.dailyLogModel.calo_threshold = calo
            self.updateDailyLog()
            print(calo)
        })
    }
    
    func updateDailyLog() {
        
        dailyLogModel.date = Date().yyyyMMdd
        RequestManager.updateDailyLog(dailyLog: dailyLogModel) { (_, _) in
            
        }
    }
}

extension ProfileVC: CalendarVCDelegate {
	func didSelectDate(date: Date) {
		dateLabel.text = date.toString()
		print(date.toString())
		self.dismiss(animated: true, completion: nil)
	}
}


