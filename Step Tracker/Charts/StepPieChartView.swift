//
//  StepPieChartView.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 24/02/25.
//

import SwiftUI
import Charts

struct StepPieChartView: View {
    
    var chartData: [WeekDayChartData]
    @State private var rawSelectedChartValue: Double? = 0
    
    var selectedWeekDay: WeekDayChartData? {
        guard let rawSelectedChartValue else { return nil}
        var total: Double = .zero
        
        
        return chartData.first {
            total += $0.value
            return rawSelectedChartValue <= total
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Label("Averages", systemImage: "calendar")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.pink)
                
                Text("Last 28 Days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weekday in
                    SectorMark(angle: .value("Average Steps", weekday.value),
                               innerRadius: .ratio(0.618),
                               outerRadius: selectedWeekDay?.date.weekDayInt == weekday.date.weekDayInt ? 140 : 110,
                               angularInset: 1)
                    .foregroundStyle(.red.gradient)
                    .cornerRadius(6)
                    .opacity(selectedWeekDay?.date.weekDayInt == weekday.date.weekDayInt ? 1.0 : 0.3)
                }
            }
            .chartAngleSelection(value: $rawSelectedChartValue.animation(.easeInOut))
            .frame(height: 240)
            .chartBackground { proxy in
                GeometryReader { geo in
                    if let plotFrame = proxy.plotFrame {
                        let frame = geo[plotFrame]
        
                        if let selectedWeekDay {
                            VStack {
                                Text(selectedWeekDay.date.weekdayTitle)
                                    .font(.title3.bold())
                                
                                Text("\(selectedWeekDay.value)")
                                    .fontWeight(.medium)
                                    .contentTransition(.interpolate)
                                    .foregroundStyle(.secondary)
                                    .contentTransition(.numericText())
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StepPieChartView(chartData: ChartMath.averageWeekdayCount(for: HealthMetricModel.mockData))
}
