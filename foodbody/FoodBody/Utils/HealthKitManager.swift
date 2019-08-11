//
//  HealthKitManager.swift
//  FoodBody
//
//  Created by Phuoc on 8/9/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import HealthKit

public enum ActivityTrackerType: Int8 {
    case notSpecify = 0
    case stepCount
    case sleepAnalysis
    case mindfulMinutes
}


public struct HealthKitStepCountResponse {
    var date: Date
    var stepCount: NSNumber
    
    init(date: Date, stepCount: NSNumber) {
        self.date = date
        self.stepCount = stepCount
    }
    
}

public struct HealthKitSleepAnalysisResponse {
    var date: Date
    var sleepTime: Date
    var wakeTime: Date
    var totalMinutes: NSNumber
    
    init(date: Date, sleepTime: Date, wakeTime: Date, totalMinutes: NSNumber) {
        self.date = date
        self.sleepTime = sleepTime
        self.wakeTime = wakeTime
        self.totalMinutes = totalMinutes
    }
    
}

public struct HealthKitMindfulMinutesResponse {
    var date: Date
    var totalMinutes: NSNumber
    var startTime: Date
    var endTime: Date
    
    init(date: Date, startTime: Date, endTime: Date, totalMinutes: NSNumber) {
        self.date = date
        self.totalMinutes = totalMinutes
        self.startTime = startTime
        self.endTime = endTime
    }
    
}


public typealias StepCountDataCompletionHandler = (_ error: Error, _ data: [HealthKitStepCountResponse]) -> Void
public typealias SleepAnalysisCompletionHandler = (_ error: Error, _ data: [HealthKitSleepAnalysisResponse]) -> Void
public typealias MindfulMinutesCompletionHandler = (_ error: Error, _ data: [HealthKitMindfulMinutesResponse]) -> Void

public class HealthKitManager {
    public static let shared = HealthKitManager()
    public let healthKitStore = HKHealthStore()
    
    public var isHealthDataAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    public var isTrackingStep: Bool {
        get {
            if let isStepTracking = UserDefaults.standard.object(forKey: "isStepTracking") as? Bool{
                return isStepTracking
            }else{
                return false
            }
        }
    }

}
