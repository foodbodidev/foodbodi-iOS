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
import CoreMotion


class ProfileVC: BaseVC {
    
    @IBOutlet weak var stepView: UIView!
	@IBOutlet weak var stepLabel: UILabel!
	@IBOutlet var chartView: PieChartView!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var caloLabel: UILabel!
	
	var rateDataSource: [Int] =  [70, 30]
	
    var totalCalo: Double =  AppManager.user?.daily_calo ?? 2500
	
	var totalEatToday: Double = 0
	var dateQuery: Date = Date()
    
    var stepConst = AppManager.step
    
    let dailyLogModel: DailyLogModel = DailyLogModel()
    let pedometer = CMPedometer() // use to update real time steps 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
		setupChart()
        fetchData()
        addObserver()
		getStepToday()
		updateRealTimeStep()
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
        self.title = "Profile";
        self.addRightButton();
        
    }
    
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(listenEventUpdateData), name: .kFb_update_reservation, object:nil)
    }
    
    @objc func listenEventUpdateData() {
        print(#function)
        fetchData() // update chart when have any update data
    }
    
    func addRightButton(){
        let viewFN = UIView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        viewFN.backgroundColor = UIColor.clear
        let button1 = UIButton(frame:CGRect.init(x: 0, y: 8, width: 40, height: 30))
        button1.setImage(UIImage(named: "iconmonstrLogOut7"), for: UIControl.State.normal)
        button1.addTarget(self, action: #selector(self.actionLogout), for: UIControl.Event.touchUpInside)
        viewFN.addSubview(button1)
        let rightBarButton = UIBarButtonItem(customView: viewFN)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc func actionLogout(){
        if AppManager.user?.token.isEmpty == false{
            let alert = UIAlertController(title:nil, message: "Do you want to log out ?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
                UIAlertAction in
                // It will dismiss action sheet
            }
            let action = UIAlertAction(title: "Ok", style: .default) {
                UIAlertAction in
                FBAppDelegate.gotoWelcome()
                AppManager.user = nil
            }
            alert.addAction(action)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
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
		chartView.holeRadiusPercent = 0.65//0.58
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
		
		let pFormatter = NumberFormatter()
		pFormatter.numberStyle = .percent
		pFormatter.maximumFractionDigits = 0
		pFormatter.multiplier = 1
		pFormatter.percentSymbol = " %"
		data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
		
		data.setValueFont(.systemFont(ofSize: 11, weight: .light))
		data.setValueTextColor(.black)
		
		chartView.data = data
		chartView.highlightValues(nil)
	}
    
    func fetchData() {
		let yesterday = Date().dayBefore
		let today = Date(timeInterval: 86400, since: yesterday)
		getData(dateQuery: today) // get data of today
    }
	
	func getData(dateQuery: Date) {
        self.showLoading()
		HealthKitManager.shared.getSteps(dateQuery: dateQuery, completion: { step in
            RequestManager.getDailyLog(dateString: dateQuery.yyyyMMdd) { (result, error) in
                self.hideLoading()
				
				var steps = step
				
				if dateQuery.yyyyMMdd == Date().yyyyMMdd {
					self.totalEatToday = result?.total_eat ?? 0
					if steps > AppManager.step {
						AppManager.step = steps
					} else {
						steps = AppManager.step
					}
				}
				
                let caloLeft = self.caculateCaloriesLeft(steps: steps, caloEten: result?.total_eat ?? 0)
                self.bindData(steps: steps, caloLeft: caloLeft)
                self.updateDailyLog(date: dateQuery, step: steps, caloLeft: caloLeft)
            }
		})
	}
	
	func getStepToday() {
		let yesterday = Date().dayBefore
		let today = Date(timeInterval: 86400, since: yesterday)
		self.showLoading()
		HealthKitManager.shared.getSteps(dateQuery: today, completion: { step in
			var steps = step
			if steps > AppManager.step {
				AppManager.step = steps
			} else {
				steps = AppManager.step
			}
			
			let caloLeft = self.caculateCaloriesLeft(steps: steps, caloEten: self.totalEatToday)
			self.bindData(steps: steps, caloLeft: caloLeft)
			self.hideLoading()
		})
	}
	
	
    func bindData(steps: Int, caloLeft: String) {
        
        if totalCalo == 0 {
            return
        }
        
        DispatchQueue.main.async {
            let caloLeftRate = Double(caloLeft)!/self.totalCalo*100
            self.stepLabel.text = "\(Int(steps)) Steps"
            self.caloLabel.text = caloLeft
            self.rateDataSource = [Int(caloLeftRate), 100 - Int(caloLeftRate)]
            self.updateChartData()
        }
	}
	
	func updateRealTimeStep() {
		//update realtime steps
		self.pedometer.startUpdates(from: Date()) { (data, error) in
			guard let activityData = data else {
				return
			}
			DispatchQueue.main.async {
				if self.dateQuery.yyyyMMdd == Date().yyyyMMdd {
                    
					let steps = self.stepConst + Int(truncating: activityData.numberOfSteps)
					self.stepLabel.text = "\(steps) Steps"
					let caloLeft = self.caculateCaloriesLeft(steps: steps, caloEten: self.totalEatToday)
					self.bindData(steps: steps, caloLeft: caloLeft)
                    
                    AppManager.step = steps
				}
			}
		}
	}
    
    func updateDailyLog(date: Date, step: Int, caloLeft: String) {
        dailyLogModel.date = date.yyyyMMdd
        dailyLogModel.step = step
        dailyLogModel.remain_calo = Double(caloLeft)
        dailyLogModel.calo_threshold = totalCalo
        RequestManager.updateDailyLog(dailyLog: dailyLogModel) { (_, _) in
            
        }
    }
	
	private func caculateCaloriesLeft(steps: Int, caloEten: Double) -> String {
        var calorLeft = totalCalo + Double(steps*20/1000) - caloEten
        if calorLeft < 0 {
            calorLeft = 0
        }
        
        if calorLeft > totalCalo {
            calorLeft = totalCalo
        }
		return NSString(format:"%.0f", calorLeft) as String
	}
    
    @IBAction func actionInputColories() {
        let inputVC = PopupInputVC.init(nibName: "PopupInputVC", bundle: nil)
        inputVC.modalTransitionStyle = .crossDissolve
        inputVC.modalPresentationStyle = .overFullScreen
        inputVC.blockDissmis = {  caloMax in
            self.totalCalo = Double(caloMax)
            if let user = AppManager.user {
                user.daily_calo = Double(caloMax)
                AppManager.user = user
            }
            self.fetchData()
        }
        self.present(inputVC, animated: true, completion: nil)
    }
}

extension ProfileVC: CalendarVCDelegate {
	func didSelectDate(date: Date) {
		dateQuery = date
		dateLabel.text = date.toString()
		getData(dateQuery: date)
		self.dismiss(animated: true, completion: nil)
	}
}


