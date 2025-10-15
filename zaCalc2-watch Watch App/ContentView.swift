//
//  ContentView.swift
//  zaCalc2 Watch App
//
//  Created by sholl on 9/29/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var calculatorData: CalculatorData

    var body: some View {
        TabView {
            WatchResultsView()
                .environmentObject(calculatorData)

            WatchToppingsView()
                .environmentObject(calculatorData)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ContentView()
}