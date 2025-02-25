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
}
