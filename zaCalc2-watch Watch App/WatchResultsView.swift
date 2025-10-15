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
        .navigationTitle("zaCalc")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WatchResultRow: View {
    let title: String
    let value: Double
    let unit: String

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
            Spacer()
            HStack(spacing: 2) {
                Text(String(format: "%.1f", value))
                Text(unit)
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