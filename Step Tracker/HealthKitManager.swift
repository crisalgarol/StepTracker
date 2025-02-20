//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 19/02/25.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    
    let store = HKHealthStore()
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
    
//    func addSimulatorData() async {
//        var mockSamples: [HKQuantitySample] = []
//        
//        for i in 0..<28 {
//            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
//            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? Date()
//            let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate) ?? Date()
//            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
//            
//            mockSamples.append(stepSample)
//            
//            // MARK: WEIGHT INFO
//            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
//            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
//            
//            mockSamples.append(weightSample)
//        }
//        
//        do {
//            try await store.save(mockSamples)
//            print("Dummy Data successfully created 👻")
//        } catch {
//            
//        }
//    }
    
}

