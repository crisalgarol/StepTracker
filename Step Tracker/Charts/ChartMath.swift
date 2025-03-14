//
//  ChartMath.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 24/02/25.
//

import Foundation
import Algorithms

struct ChartMath {
    
    static func averageWeekdayCount(for metric: [HealthMetricModel]) -> [WeekDayChartData] {
        
        let sortedByWeekDay = metric.sorted {
            $0.date.weekDayInt < $1.date.weekDayInt
        }
        let weekdayArray = sortedByWeekDay.chunked { $0.date.weekDayInt == $1.date.weekDayInt }
        
        var weekdayChartData: [WeekDayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            
            let total = array.reduce(.zero) { $0 + $1.value }
            let averageSteps = total / Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: averageSteps))
        }

        return weekdayChartData
    }
    
    static func averageDailyWeightDiffs(for weights: [HealthMetricModel]) -> [WeekDayChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        
        for i in 1..<weights.count {
            let date = weights[i].date
            let diff = weights[i].value - weights[i-1].value
            diffValues.append((date: date, value: diff))
            
        }
        
        let sortedByWeekday = diffValues.sorted { $0.date.weekDayInt < $1.date.weekDayInt }
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekDayInt == $1.date.weekDayInt }
        
        var weekDayChartData: [WeekDayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else {
                continue
            }
            
            let total = array.reduce(0) { $0 + $1.value }
            let avgWeightDiff = total / Double(array.count)
            
            weekDayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }
        
        return weekDayChartData
    }
}
