//
//  AverageWeightChartView.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 27/02/25.
//

import Charts
import SwiftUI

struct WeightDiffBarChartView: View {
    
    var chartData: [WeekDayChartData]
    @State private var rawSelectedDate: Date?
    
    var selectedData: WeekDayChartData? {
        guard let rawSelectedDate else {
            return nil
        }
        
        let selectedMetric = chartData.first { currentStepData in
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: currentStepData.date)
        }
        
        return selectedMetric
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Label("Average Weight Change", systemImage: "figure")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.indigo)
                
                Text("Per Weekday (Last 28 Days)")
                    .font(.caption)
            }
            
            
            Chart {
                if let selectedData {
                    RuleMark(x: .value("Selected Metric", selectedData.date, unit: .day))
                        .offset(y: -10)
                        .foregroundStyle(.green)
                        .annotation(position: .top,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit(to: .chart) , y: .disabled)) {
                            AnnotationView
                        }
                }
                
                ForEach(chartData) { weightDiff in
                    BarMark(x: .value("Day", weightDiff.date, unit: .day),
                            y: .value("Weight Diff", weightDiff.value))
                    .foregroundStyle(weightDiff.value > 0 ? .indigo : .teal)
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisValueLabel(format: .dateTime.weekday(), centered: true)

                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    
                    AxisValueLabel()
                }
            }

        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var AnnotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedData?.date ?? .now,
                 format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedData?.value ?? .zero, format: .number.precision(.fractionLength(2)))
                .fontWeight(.heavy)
                .foregroundStyle((selectedData?.value ?? 0) > 0 ? .indigo : .teal )
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.6),
                        radius: 2, x: 1, y: 1)
        )
        
    }
}

#Preview {
    WeightDiffBarChartView(chartData: ChartMath.averageDailyWeightDiffs(for: MockData.weights) )
}
