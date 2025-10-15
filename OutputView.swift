//
//  OutputView.swift
//  zaCalc2
//
//  Created by sholl on 9/27/25.
//

import SwiftUI

struct OutputView: View {
    @EnvironmentObject var calculatorData: CalculatorData

    var body: some View {
        List {
                Section("Dough Information") {
                    ResultRow(title: "Total Dough Weight", value: calculatorData.totalDoughWeight, unit: calculatorData.useOunces ? "oz" : "g", precision: 0)
                    ResultRow(title: "Ball Weight", value: calculatorData.ballWeight, unit: calculatorData.useOunces ? "oz" : "g", precision: 0)
                }

                if calculatorData.yeastType == .sourdough {
                    Section("Flour Breakdown") {
                        ResultRow(title: "Total Flour", value: calculatorData.totalFlour, unit: calculatorData.useOunces ? "oz" : "g", precision: 0)
                        ResultRow(title: "Flour from Preferment", value: calculatorData.prefermentFlour, unit: calculatorData.useOunces ? "oz" : "g", precision: 0)
                    }

                    Section("Preferment") {
                        ResultRow(title: "Total Preferment", value: calculatorData.totalPreferment, unit: calculatorData.useOunces ? "oz" : "g", precision: 0)
                    }

                    Section("Final Ingredients") {
                        ResultRow(title: "Water", value: calculatorData.water, unit: calculatorData.useOunces ? "fl oz" : "ml", precision: 0, isWeight: false, isVolume: true)
                        ResultRow(title: "Salt", value: calculatorData.saltAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                        ResultRow(title: "Oil", value: calculatorData.oilAmount, unit: calculatorData.useOunces ? "fl oz" : "ml", precision: 2, isWeight: false, isVolume: true)
                        ResultRow(title: "Sugar", value: calculatorData.sugarAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                    }
                } else {
                    Section("Recipe Ingredients") {
                        ResultRow(title: "Total Flour", value: calculatorData.totalFlour, unit: calculatorData.useOunces ? "oz" : "g", precision: 0)
                        ResultRow(title: "Baker's Yeast (\(calculatorData.bakersYeastType.displayName))", value: calculatorData.bakersYeastAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                        ResultRow(title: "Water", value: calculatorData.water, unit: calculatorData.useOunces ? "fl oz" : "ml", precision: 0, isWeight: false, isVolume: true)
                        ResultRow(title: "Salt", value: calculatorData.saltAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                        ResultRow(title: "Oil", value: calculatorData.oilAmount, unit: calculatorData.useOunces ? "fl oz" : "ml", precision: 2, isWeight: false, isVolume: true)
                        ResultRow(title: "Sugar", value: calculatorData.sugarAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                    }
                }

            }
            .navigationTitle("Results")
    }
}

struct ResultRow: View {
    let title: String
    let value: Double
    let unit: String
    let precision: Int
    let isWeight: Bool
    let isVolume: Bool

    @EnvironmentObject var calculatorData: CalculatorData

    init(title: String, value: Double, unit: String, precision: Int = 2, isWeight: Bool = true, isVolume: Bool = false) {
        self.title = title
        self.value = value
        self.unit = unit
        self.precision = precision
        self.isWeight = isWeight
        self.isVolume = isVolume
    }

    var convertedValue: Double {
        if isWeight && unit.contains("oz") && !unit.contains("fl") {
            // Convert grams to ounces (1 oz = 28.3495 g)
            return value / 28.3495
        } else if isVolume && (unit == "fl oz" || unit.contains("fl")) {
            // Convert ml to fl oz (1 fl oz = 29.5735 ml)
            return value / 29.5735
        }
        return value
    }

    var displayText: String {
        let converted = convertedValue

        // For weights in ounces > 16 oz, show as lb/oz format
        if isWeight && unit.contains("oz") && !unit.contains("fl") && converted > 16 {
            let pounds = Int(converted / 16)
            let ounces = converted.truncatingRemainder(dividingBy: 16)
            if ounces < 0.1 {
                return "\(pounds) lb"
            } else {
                return String(format: "\(pounds) lb %.1f oz", ounces)
            }
        }

        return String(format: "%.\(precision)f", converted)
    }

    var displayUnit: String {
        let converted = convertedValue

        // For lb/oz format, don't show unit (already included in displayText)
        if isWeight && unit.contains("oz") && !unit.contains("fl") && converted > 16 {
            return ""
        }

        return unit
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            HStack(spacing: 4) {
                Text(displayText)
                    .font(.headline)
                if !displayUnit.isEmpty {
                    Text(displayUnit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}


#Preview {
    OutputView()
        .environmentObject(CalculatorData())
}
