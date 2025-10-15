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
                        ResultRow(title: "Water", value: calculatorData.water, unit: calculatorData.useOunces ? "fl oz" : "ml", precision: 0)
                        ResultRow(title: "Salt", value: calculatorData.saltAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                        ResultRow(title: "Oil", value: calculatorData.oilAmount, unit: calculatorData.useOunces ? "fl oz" : "ml", precision: 2)
                        ResultRow(title: "Sugar", value: calculatorData.sugarAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                    }
                } else {
                    Section("Recipe Ingredients") {
                        ResultRow(title: "Total Flour", value: calculatorData.totalFlour, unit: calculatorData.useOunces ? "oz" : "g", precision: 0)
                        ResultRow(title: "Baker's Yeast (\(calculatorData.bakersYeastType.displayName))", value: calculatorData.bakersYeastAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                        ResultRow(title: "Water", value: calculatorData.water, unit: calculatorData.useOunces ? "fl oz" : "ml", precision: 0)
                        ResultRow(title: "Salt", value: calculatorData.saltAmount, unit: calculatorData.useOunces ? "oz" : "g", precision: 2)
                        ResultRow(title: "Oil", value: calculatorData.oilAmount, unit: calculatorData.useOunces ? "fl oz" : "ml", precision: 2)
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

    init(title: String, value: Double, unit: String, precision: Int = 2) {
        self.title = title
        self.value = value
        self.unit = unit
        self.precision = precision
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            HStack(spacing: 4) {
                Text(String(format: "%.\(precision)f", value))
                    .font(.headline)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}


#Preview {
    OutputView()
        .environmentObject(CalculatorData())
}
