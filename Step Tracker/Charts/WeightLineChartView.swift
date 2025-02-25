//
//  WeightLineChartView.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 25/02/25.
//

import Charts
import SwiftUI

struct WeightLineChartView: View {
    
    @State var selectedStat: HealthMetricContext
    var chartData: [HealthMetricModel]
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Weight", systemImage: "figure")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.indigo)
                        
                        Text("Avg: \(Int(10))k Steps")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weight in
                    AreaMark(x: .value("Day", weight.date, unit: .day),
                             y: .value("Value", weight.value))
                    .foregroundStyle(Gradient(colors: [.blue.opacity(0.5), .clear]))
                    
                    LineMark(x: .value("Day", weight.date, unit: .day),
                             y: .value("Value", weight.value))
                }
            }
            .frame(height: 150)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    WeightLineChartView(selectedStat: .steps, chartData: MockData.weights)
}
