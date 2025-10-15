//
//  WatchResultsView.swift
//  zaCalc2 Watch App
//
//  Created by sholl on 9/29/25.
//

import SwiftUI

struct WatchResultsView: View {
    @EnvironmentObject var calculatorData: CalculatorData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Group {
                    WatchResultRow(title: "Total Dough", value: calculatorData.totalDoughWeight, unit: calculatorData.useOunces ? "oz" : "g")
                    WatchResultRow(title: "Ball Weight", value: calculatorData.ballWeight, unit: calculatorData.useOunces ? "oz" : "g")
                    WatchResultRow(title: "Total Flour", value: calculatorData.totalFlour, unit: calculatorData.useOunces ? "oz" : "g")
                }

                if calculatorData.yeastType == .sourdough {
                    Group {
                        WatchResultRow(title: "Preferment Flour", value: calculatorData.prefermentFlour, unit: calculatorData.useOunces ? "oz" : "g")
                        WatchResultRow(title: "Total Preferment", value: calculatorData.totalPreferment, unit: calculatorData.useOunces ? "oz" : "g")
                    }
                } else {
                    WatchResultRow(title: calculatorData.bakersYeastType.displayName, value: calculatorData.bakersYeastAmount, unit: calculatorData.useOunces ? "oz" : "g")
                }

                Group {
                    WatchResultRow(title: "Water", value: calculatorData.water, unit: calculatorData.useOunces ? "fl oz" : "ml")
                    WatchResultRow(title: "Salt", value: calculatorData.saltAmount, unit: calculatorData.useOunces ? "oz" : "g")
                    WatchResultRow(title: "Oil", value: calculatorData.oilAmount, unit: calculatorData.useOunces ? "fl oz" : "ml")
                    WatchResultRow(title: "Sugar", value: calculatorData.sugarAmount, unit: calculatorData.useOunces ? "oz" : "g")
                }
            }
            .padding()
        }
        .navigationTitle("zaCalc2")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WatchResultRow: View {
    let title: String
    let value: Double
    let unit: String

    var convertedValue: Double {
        if unit == "oz" {
            // Convert grams to ounces (1 oz = 28.3495 g)
            return value / 28.3495
        } else if unit == "fl oz" {
            // Convert ml to fl oz (1 fl oz = 29.5735 ml)
            return value / 29.5735
        }
        return value
    }

    var displayText: String {
        let converted = convertedValue

        // For weights in ounces > 16 oz, show as lb/oz format
        if unit == "oz" && converted > 16 {
            let pounds = Int(converted / 16)
            let ounces = converted.truncatingRemainder(dividingBy: 16)
            if ounces < 0.1 {
                return "\(pounds) lb"
            } else {
                return String(format: "\(pounds) lb %.1f oz", ounces)
            }
        }

        return String(format: "%.1f", converted)
    }

    var displayUnit: String {
        let converted = convertedValue

        // For lb/oz format, don't show unit (already included in displayText)
        if unit == "oz" && converted > 16 {
            return ""
        }

        return unit
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
            Spacer()
            HStack(spacing: 2) {
                Text(displayText)
                if !displayUnit.isEmpty {
                    Text(displayUnit)
                }
            }
            .font(.body)
            .fontWeight(.regular)
        }
    }
}

#Preview {
    WatchResultsView()
        .environmentObject(CalculatorData())
}