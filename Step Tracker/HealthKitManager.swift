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
}
