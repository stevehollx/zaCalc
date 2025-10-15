//
//  WatchToppingsView.swift
//  zaCalc2 Watch App
//
//  Created by sholl on 9/29/25.
//

import SwiftUI

struct WatchToppingsView: View {
    @EnvironmentObject var calculatorData: CalculatorData

    var currentStyle: CalculatorData.CustomPizzaStyle? {
        if let selectedId = calculatorData.selectedCustomStyleId {
            return calculatorData.customPizzaStyles.first { $0.id == selectedId }
        }
        return calculatorData.customPizzaStyles.first
    }

    var scalingFactor: Double {
        guard let style = currentStyle else { return 1.0 }
        let actualArea = 3.1415 * pow(calculatorData.toppingsSize / 2, 2)
        let referenceArea = 3.1415 * pow(style.referenceSize / 2, 2)
        return actualArea / referenceArea
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                // Pizza size info
                WatchResultRow(title: "Pizza Size", value: calculatorData.toppingsSize, unit: "in")

                if let style = currentStyle {
                    WatchTextRow(title: "Style", text: style.name)

                    Divider()
                        .padding(.vertical, 4)

                    // Scaled toppings
                    ForEach(style.toppings) { topping in
                        WatchResultRow(
                            title: topping.name,
                            value: topping.amount * scalingFactor,
                            unit: topping.unit
                        )
                    }

                    Divider()
                        .padding(.vertical, 4)

                    // Scaling info
                    Text("Scaled from \(String(format: "%.1f", style.referenceSize))\" to \(String(format: "%.1f", calculatorData.toppingsSize))\"")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .navigationTitle("Toppings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WatchTextRow: View {
    let title: String
    let text: String

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.bold)
            Spacer()
            Text(text)
                .font(.body)
                .fontWeight(.regular)
        }
    }
}

#Preview {
    WatchToppingsView()
        .environmentObject(CalculatorData())
}