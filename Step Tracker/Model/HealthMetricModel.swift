//
//  HealthMetricModel.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 22/02/25.
//

import Foundation

struct HealthMetricModel: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    
    static var mockData: [HealthMetricModel] {
        var array: [HealthMetricModel] = []
        
        for i in 0..<28 {
            let metric = HealthMetricModel(date: Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now,
                                           value: .random(in: 4_000...15_000))
            array.append(metric)
        }
        
        return array
    }
}
