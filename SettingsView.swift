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
                    "all the forum members that tested and helped improve the models.\n\n" +
                    "Given that that data was open to the community, this app will always remain free " +
                    "and updated on my best effort."
                ).foregroundColor(.secondary)
            } header: {
                Text("About")
            }
        })
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: calculatorData.useCentimeters) { newValue in
            // Convert diameter and thickness when switching units
            if newValue {
                // Converting from inches to centimeters
                calculatorData.diameter = calculatorData.diameter * 2.54
                calculatorData.thickness = calculatorData.thickness * 2.54
                calculatorData.toppingsSize = calculatorData.toppingsSize * 2.54
            } else {
                // Converting from centimeters to inches
                calculatorData.diameter = calculatorData.diameter / 2.54
                calculatorData.thickness = calculatorData.thickness / 2.54
                calculatorData.toppingsSize = calculatorData.toppingsSize / 2.54
            }
            calculatorData.saveToDefaults()
            WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
        }
        .onChange(of: calculatorData.useOunces) { _ in
            calculatorData.saveToDefaults()
            WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
        }
        .onChange(of: calculatorData.useCelsius) { newValue in
            // Convert temperatures when switching units
            if newValue {
                // Converting from Fahrenheit to Celsius
                calculatorData.temp1 = (calculatorData.temp1 - 32) * 5 / 9
                calculatorData.temp2 = (calculatorData.temp2 - 32) * 5 / 9
                calculatorData.temp3 = (calculatorData.temp3 - 32) * 5 / 9
                calculatorData.temp4 = (calculatorData.temp4 - 32) * 5 / 9
                calculatorData.temp5 = (calculatorData.temp5 - 32) * 5 / 9
                calculatorData.desiredFermentationTemp = (calculatorData.desiredFermentationTemp - 32) * 5 / 9
            } else {
                // Converting from Celsius to Fahrenheit
                calculatorData.temp1 = calculatorData.temp1 * 9 / 5 + 32
                calculatorData.temp2 = calculatorData.temp2 * 9 / 5 + 32
                calculatorData.temp3 = calculatorData.temp3 * 9 / 5 + 32
                calculatorData.temp4 = calculatorData.temp4 * 9 / 5 + 32
                calculatorData.temp5 = calculatorData.temp5 * 9 / 5 + 32
                calculatorData.desiredFermentationTemp = calculatorData.desiredFermentationTemp * 9 / 5 + 32
            }
            calculatorData.saveToDefaults()
            WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
        }
        .onChange(of: calculatorData.yeastType) { _ in
            calculatorData.saveToDefaults()
            WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(CalculatorData())
}