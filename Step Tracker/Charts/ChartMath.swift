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
}
