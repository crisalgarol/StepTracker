//
//  DashboardView.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 18/02/25.
//

import SwiftUI
import Charts

enum HealthMetricContext: CaseIterable, Identifiable {
    var id: Self {
        self
    }
    
    case steps
    case weight
    
    var title: String {
        switch self {
        case .steps:
            return "Steps"
        case .weight:
            return "Weight"
        }
    }
}

struct DashboardView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @AppStorage("hasSeenPermissionPriming") private var hasSeenPermissionPriming = false
    @State var isShowingPermissionPrimingSheet: Bool = false
    @State private var selectedStat: HealthMetricContext = .steps
    var isSteps: Bool { selectedStat == .steps }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Picker("Selected Stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    StepBarChartView(selectedStat: selectedStat,
                                     chartData: hkManager.stepData)
                    
                    StepPieChartView(chartData: ChartMath.averageWeekdayCount(for: hkManager.weightData))
                }
            }
            .onAppear {
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            }
            .task {
//                await hkManager.addSimulatorData()
                await hkManager.fetchStepCount()
                await hkManager.fetchWeights()
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self, destination: { metric in
                HealthDataListView(metric: metric)
            })
            .sheet(isPresented: $isShowingPermissionPrimingSheet, onDismiss: {
                // Fetch Health Data
            }, content: {
                HealthKitPermissionPrimingView(hasSeen: $hasSeenPermissionPriming)
            })
            .padding()
        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
