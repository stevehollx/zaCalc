//
//  ContentView.swift
//  zaCalc2
//
//  Created by sholl on 9/27/25.
//

import SwiftUI
import CoreGraphics

struct ContentView: View {
    @StateObject private var calculatorData = CalculatorData()
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                if calculatorData.yeastType == .sourdough {
                    SourdoughCalculatorView(selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: "flask.fill")
                            Text("Sourdough")
                        }
                        .tag(0)
                } else {
                    BakersYeastView(selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: "allergens")
                            Text("Baker's Yeast")
                        }
                        .tag(0)
                }

                RecipeInputView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("Recipe")
                    }
                    .tag(1)

                OutputView()
                    .tabItem {
                        Image(systemName: "doc.text")
                        Text("Results")
                    }
                    .tag(2)

                ToppingsView()
                    .tabItem {
                        Image(systemName: "leaf.fill")
                        Text("Toppings")
                    }
                    .tag(3)
            }
            .highPriorityGesture(
                DragGesture(minimumDistance: 100, coordinateSpace: .global)
                    .onChanged { _ in
                        // Do nothing during drag - this prevents interference with taps
                    }
                    .onEnded { dragValue in
                        let translation = dragValue.translation
                        let velocity = dragValue.velocity
                        let threshold: CGFloat = 100.0
                        let velocityThreshold: CGFloat = 300.0

                        // Only trigger on fast, long horizontal swipes
                        if abs(translation.width) > threshold &&
                           abs(velocity.width) > velocityThreshold &&
                           abs(translation.width) > abs(translation.height) * 1.5 {

                            if translation.width > 0 && velocity.width > 0 {
                                // Fast swipe right - go to previous tab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = max(0, selectedTab - 1)
                                }
                            } else if translation.width < 0 && velocity.width < 0 {
                                // Fast swipe left - go to next tab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = min(3, selectedTab + 1)
                                }
                            }
                        }
                    }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .navigationTitle("zaCalc2")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .environmentObject(calculatorData)
        // TODO: Uncomment after adding WatchConnectivityManager.swift to the iOS target in Xcode
        // .onAppear {
        //     WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
        // }
    }
}

#Preview {
    ContentView()
}
