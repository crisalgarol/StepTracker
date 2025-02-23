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
    @State private var rawSelectedDate: Date?
    var isSteps: Bool { selectedStat == .steps }
    
    var averageStepCount: Double {
        guard !hkManager.stepData.isEmpty else {
            return 9
        }
        
        let totalSteps = hkManager.stepData.reduce(0) { $0 + $1.value}
        return totalSteps / Double(hkManager.stepData.count)
    }
    
    var selectedHealthMetric: HealthMetricModel? {
        guard let rawSelectedDate else {
            return nil
        }
        
        let selectedMetric = hkManager.stepData.first { currentStepData in
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: currentStepData.date)
        }
        
        return selectedMetric
    }
    
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
                            
                            ForEach(hkManager.stepData) { steps in
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
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
            .onAppear {
                isShowingPermissionPrimingSheet = !hasSeenPermissionPriming
            }
            .task {
//                await hkManager.addSimulatorData()
                await hkManager.fetchStepCount()
//                await hkManager.fetchWeights()
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
    DashboardView()
        .environment(HealthKitManager())
}
