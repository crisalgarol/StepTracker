//
//  StepBarChartView.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 22/02/25.
//

import Charts
import SwiftUI

struct StepBarChartView: View {
    
    @State private var rawSelectedDate: Date?
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetricModel]

    var averageStepCount: Double {
        guard !chartData.isEmpty else {
            return 10
        }
        
        let totalSteps = chartData.reduce(0) { $0 + $1.value}
        return totalSteps / Double(chartData.count)
    }
    
    var selectedHealthMetric: HealthMetricModel? {
        guard let rawSelectedDate else {
            return nil
        }
        
        let selectedMetric = chartData.first { currentStepData in
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: currentStepData.date)
        }
        
        return selectedMetric
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Steps", systemImage: "figure.walk")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.pink)
                        
                        Text("Avg: \(Int(averageStepCount))k Steps")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                    
                }
                .padding(.bottom, 12)
            }
            .foregroundStyle(.secondary)
            
            Chart {
                if let selectedHealthMetric {
                    RuleMark(x: .value("Selected Metric", selectedHealthMetric.date, unit: .day))
                        .offset(y: -10)
                        .foregroundStyle(.green)
                        .annotation(position: .top,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit(to: .chart) , y: .disabled)) {
                            AnnotationView
                        }
                }
                
                RuleMark(y: .value("Average", averageStepCount))
                    .foregroundStyle(Color.secondary)
                    .lineStyle(.init(lineWidth: 1, dash: [5]))
                
                ForEach(chartData) { steps in
                    BarMark(x: .value("Date", steps.date, unit: .day),
                            y: .value("Steps", steps.value)
                    )
                    .foregroundStyle(.pink.gradient)
                    .opacity(rawSelectedDate == nil || steps.date == selectedHealthMetric?.date ? 1 : 0.3)
                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.defaultDigits).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(.red)
                    
                    AxisValueLabel((value.as(Double.self) ?? 0)
                        .formatted(.number.notation(.compactName))
                    )
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
    
    var AnnotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedHealthMetric?.date ?? .now,
                 format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedHealthMetric?.value ?? .zero, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(.pink)
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
    StepBarChartView(selectedStat: .steps,
                     chartData: HealthMetricModel.mockData)
}
