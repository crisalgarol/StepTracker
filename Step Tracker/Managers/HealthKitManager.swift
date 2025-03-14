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
    var stepData: [HealthMetricModel] = []
    var weightData: [HealthMetricModel] = []
    var weightDiffData: [HealthMetricModel] = []

    func fetchStepCount() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.stepCount), predicate: queryPredicate)
        let stepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                               options: .cumulativeSum,
                                                               anchorDate: endDate,
                                                               intervalComponents: .init(day: 1))
        do {
            let stepCounts = try await stepsQuery.result(for: store)
            stepData = stepCounts.statistics().map {
                HealthMetricModel(date: $0.startDate,
                                  value: $0.sumQuantity()?.doubleValue(for: .count()) ?? 0)
            }
        } catch {
            
        }
    }
    
    func fetchWeights() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
        let startDate = calendar.date(byAdding: .day, value: -28, to: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        let weightsQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                                 options: .mostRecent,
                                                                 anchorDate: endDate,
                                                                 intervalComponents: .init(day: 1))
        
        do {
            let weightCounts = try await weightsQuery.result(for: store)
            weightData = weightCounts.statistics().map {
                HealthMetricModel(date: $0.startDate,
                                  value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch {
            
        }
    }
    
    func fetchWeightsForDifferentials() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endDate = calendar.date(byAdding: .day, value: 1, to: today) ?? Date()
        let startDate = calendar.date(byAdding: .day, value: -29, to: endDate)
        
        let queryPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: HKQuantityType(.bodyMass), predicate: queryPredicate)
        let weightsQuery = HKStatisticsCollectionQueryDescriptor(predicate: samplePredicate,
                                                                 options: .mostRecent,
                                                                 anchorDate: endDate,
                                                                 intervalComponents: .init(day: 1))
        
        do {
            let weightCounts = try await weightsQuery.result(for: store)
            weightDiffData = weightCounts.statistics().map {
                HealthMetricModel(date: $0.startDate,
                                  value: $0.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0)
            }
        } catch {
            
        }
    }
}

extension HealthKitManager {
    func addSimulatorData() async {
        var mockSamples: [HKQuantitySample] = []
        
        for i in 0..<28 {
            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? Date()
            let endDate = Calendar.current.date(byAdding: .second, value: 1, to: startDate) ?? Date()
            let stepSample = HKQuantitySample(type: HKQuantityType(.stepCount), quantity: stepQuantity, start: startDate, end: endDate)
            
            mockSamples.append(stepSample)
            
            // MARK: WEIGHT INFO
            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
            let weightSample = HKQuantitySample(type: HKQuantityType(.bodyMass), quantity: weightQuantity, start: startDate, end: endDate)
            
            mockSamples.append(weightSample)
        }
        
        do {
            try await store.save(mockSamples)
            print("Dummy Data successfully created 👻")
        } catch {
            
        }
    }
}

