//
//  WeekDayChartData.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 24/02/25.
//

import Foundation

struct WeekDayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
