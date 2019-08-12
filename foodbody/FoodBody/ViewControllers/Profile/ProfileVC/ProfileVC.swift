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


class ProfileVC: UIViewController {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    @IBOutlet weak var stepView: UIView!
	@IBOutlet var chartView: PieChartView!
	
	var rateDataSource: [Int] =  [70, 30]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
		setupChart()
        HealthKitManager.shared.getTodaysSteps(completion: { step in
            
            print(step)
        })
       
    }
    
    
    private func setupLayout() {
       stepView.layer.borderColor = Style.Color.showDowColor.cgColor
       stepView.layer.borderWidth = 1
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
    

    @IBAction func logoutPress(sender:UIButton){
        AppManager.user = nil
        FBAppDelegate.gotoWelcome()
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
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        
        let healthStore = HKHealthStore()
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let yesterday = Date(timeInterval: -86400, since: Date())
        let now = Date()
        let predicate = HKQuery.predicateForSamples(withStart: yesterday, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
    
    func retrieveStepCount(completion: @escaping (_ stepRetrieved: Double) -> Void) {
        
        let yesterday = Date(timeInterval: -86400, since: Date())
        let now = Date()
        
        let healthStore = HKHealthStore()

        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)

        //   Get the start of the day
        let date = Date()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date)

        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1

        //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval)

        query.initialResultsHandler = { query, results, error in

            if error != nil {

                //  Something went Wrong
                return
            }

            if let myResults = results{
                myResults.enumerateStatistics(from: yesterday, to: now) {
                    statistics, stop in

                    if let quantity = statistics.sumQuantity() {

                        let steps = quantity.doubleValue(for: HKUnit.count())

                        print("Steps = \(steps)")
                       

                    }
                }
            }


        }

        healthStore.execute(query)
    }
    
}


