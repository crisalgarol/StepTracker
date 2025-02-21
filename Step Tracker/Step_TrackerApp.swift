//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Cristian Olmedo on 18/02/25.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    
    let HKManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(HKManager)
        }
    }
}
