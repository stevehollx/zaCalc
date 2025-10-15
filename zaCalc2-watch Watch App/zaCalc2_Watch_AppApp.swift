//
//  zaCalc2_Watch_AppApp.swift
//  zaCalc2 Watch App
//
//  Created by sholl on 9/29/25.
//

import SwiftUI

@main
struct zaCalc2_Watch_App: App {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connectivityManager.calculatorData)
        }
    }
}