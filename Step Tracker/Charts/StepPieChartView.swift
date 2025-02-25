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
                               angularInset: 1)
                    .foregroundStyle(.teal.gradient)
                    .cornerRadius(40)
                }
            }
            .frame(height: 240)
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StepPieChartView(chartData: ChartMath.averageWeekdayCount(for: HealthMetricModel.mockData))
}
