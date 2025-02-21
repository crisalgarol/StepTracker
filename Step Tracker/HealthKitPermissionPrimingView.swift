//
//  HealthKitPermissionPrimingView.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 19/02/25.
//

import SwiftUI
import HealthKitUI

struct HealthKitPermissionPrimingView: View {
    
    @Environment(HealthKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingPermissionRequest = false
    @Binding var hasSeen: Bool
    
    var description = """
    This app displays your step and weight in interactive charts.
    
    You can also add new step or weight data to Apple Health from this app. Your data is private and secured
    """
    
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 10) {
                Image(.appleHealth)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                    .padding(.bottom, 12)
                
                Text("Apple Health Integration")
                    .font(.title2)
                    .bold()
                
                Text(description)
                    .foregroundStyle(.secondary)
            }
            
            Button("Connect Apple Health") {
                isShowingPermissionRequest = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(30)
        .interactiveDismissDisabled()
        .onAppear {
            hasSeen = true
        }
        .healthDataAccessRequest(store: hkManager.store,
                                 shareTypes: hkManager.types,
                                 readTypes: hkManager.types,
                                 trigger: isShowingPermissionRequest) { result in
            switch result {
            case .success(let success):
                dismiss()
            case .failure(let failure):
                // Handle error later
                dismiss()
            }
        }
    }
}

#Preview {
    HealthKitPermissionPrimingView(hasSeen: .constant(true))
        .environment(HealthKitManager())
}
