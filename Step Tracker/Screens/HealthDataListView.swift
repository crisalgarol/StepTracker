//
//  HealthDataListView.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 19/02/25.
//

import SwiftUI

struct HealthDataListView: View {
    
    var metric: HealthMetricContext
    @Environment(HealthKitManager.self) private var hkManager
    @State private var isShowingAddData = false
    @State private var addDataDate: Date = .now
    @State private var valueToAdd: String = ""
    
    var listData: [HealthMetricModel] {
        metric == .steps ? hkManager.stepData : hkManager.weightData
    }
    
    var body: some View {
        List(listData.reversed()) { currentData in
            HStack {
                Text(currentData.date, format: .dateTime.month(.wide).day().year())
                Spacer()
                Text(currentData.value, format: .number.precision(.fractionLength(metric == .steps ? 0 : 1)))
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingAddData) {
            addDataView
        }
        .toolbar {
            Button("Add Data", systemImage: "plus") {
                isShowingAddData = true
            }
        }
    }
    
    var addDataView: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $addDataDate, displayedComponents: .date)
                
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(metric == .steps ? .numberPad : .decimalPad)
                        .frame(width: 140)
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        Task {
                            switch metric {
                            case .steps:
                                await hkManager.addStepData(for: addDataDate, value: Double(valueToAdd) ?? 0)
                                await hkManager.fetchStepCount()
                            case .weight:
                                await hkManager.addWeightData(for: addDataDate, value: Double(valueToAdd) ?? 0)
                                await hkManager.fetchWeights()
                                await hkManager.fetchWeightsForDifferentials()
                            }
                            
                            DispatchQueue.main.async {
                                isShowingAddData = false
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingAddData = false
                    }
                }
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        HealthDataListView(metric: .weight)
            .environment(HealthKitManager())
    }
}
