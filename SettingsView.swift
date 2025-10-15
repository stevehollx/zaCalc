//
//  SettingsView.swift
//  zaCalc2
//
//  Created by sholl on 9/27/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var calculatorData: CalculatorData

    var body: some View {
        Form(content: {
            Section {
                Toggle("Use Centimeters", isOn: $calculatorData.useCentimeters)
                Toggle("Use Ounces", isOn: $calculatorData.useOunces)
                Toggle("Use Celsius", isOn: $calculatorData.useCelsius)
            } header: {
                Text("Measurement Units")
            } footer: {
                Text("Default: Inches for size, Grams for weight, Fahrenheit for temperature.")
            }

            Section {
                Picker("Yeast Type", selection: $calculatorData.yeastType) {
                    ForEach(CalculatorData.YeastType.allCases, id: \.self) { yeastType in
                        Text(yeastType.displayName).tag(yeastType)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Yeast Type")
            } footer: {
                Text("Choose between sourdough starter or baker's yeast calculations.")
            }

            Section {
                Text(
                    "zaCalc app is written by Steve Holl.\n\n" +
                    "A special thanks goes to TXCraig1 from the pizzamaking.com forums, for his efforts " +
                    "to publish the dough fermentation models for sourdough and baking yeast, and for " +
                    "all that.\n\n" +
                    "Given that that data was open to the community, this app will always remain free " +
                    "and updated on my best effort."
                ).foregroundColor(.secondary)
            } header: {
                Text("About")
            }
        })
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: calculatorData.useCentimeters) { _ in
            calculatorData.saveToDefaults()
        }
        .onChange(of: calculatorData.useOunces) { _ in
            calculatorData.saveToDefaults()
        }
        .onChange(of: calculatorData.useCelsius) { _ in
            calculatorData.saveToDefaults()
        }
        .onChange(of: calculatorData.yeastType) { _ in
            calculatorData.saveToDefaults()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(CalculatorData())
}