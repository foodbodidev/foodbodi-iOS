//
//  HealthKitManager.swift
//  FoodBody
//
//  Created by Phuoc on 8/9/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import Foundation
import HealthKit


class HealthKitManager {
    
    static let shared: HealthKitManager = HealthKitManager()
    
    let healthStore = HKHealthStore()
    
    
    private init () { }
    
    
    func checkAuth() -> Bool {
        
        var success = true
        if HKHealthStore.isHealthDataAvailable() {
            let allType = Set([HKObjectType.workoutType(),
                               HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                               HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                               HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                               HKObjectType.quantityType(forIdentifier: .stepCount)!])
            healthStore.requestAuthorization(toShare: nil, read: allType) { bool, error in
                success = bool
            }
        }
        else {
            return false
        }
        return success
    }
    
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        
        guard checkAuth() else {
            return 
        }
    
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
    
    func getCaloriesConsumed(completion: @escaping (Double)-> ()) {
        guard checkAuth() else {
            return
        }
        
        let caloQuantityType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let yesterday = Date(timeInterval: -86400, since: Date())
        let now = Date()
        let predicate = HKQuery.predicateForSamples(withStart: yesterday, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: caloQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }

}

