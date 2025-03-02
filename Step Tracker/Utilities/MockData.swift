//
//  MockData.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 25/02/25.
//

import Foundation

struct MockData {
    
    static var steps: [HealthMetricModel] {
        var array: [HealthMetricModel] = []
        
        for i in 0..<28 {
            let metric = HealthMetricModel(date: Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now,
                                           value: .random(in: 4_000...15_000))
            array.append(metric)
        }
        
        return array
    }
    
    static var weights: [HealthMetricModel] {
        var array: [HealthMetricModel] = []
        
        for i in 0..<28 {
            let metric = HealthMetricModel(date: Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now,
                                           value: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
            array.append(metric)
        }
        
        return array
    }
    
    static var weightDifferencials: [HealthMetricModel] {
        var array: [HealthMetricModel] = []
        
        for i in 0..<29 {
            let metric = HealthMetricModel(date: Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now,
                                           value: .random(in: (160 + Double(i/3)...165 + Double(i/3))))
            array.append(metric)
        }
        
        return array
    }
    
}
