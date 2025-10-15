//
//  App.swift
//  zaCalc2
//
//  Created by sholl on 9/27/25.
//

import SwiftUI

@main
struct ZaCalcApp: App {
    init() {
        // Initialize WatchConnectivityManager to activate the session
        _ = WatchConnectivityManager.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
