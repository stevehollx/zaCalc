//
//  BakersYeastView.swift
//  zaCalc2
//
//  Created by sholl on 9/27/25.
//

import SwiftUI
import Foundation

struct BakersYeastView: View {
    @EnvironmentObject var calculatorData: CalculatorData
    @FocusState private var focusedField: Field?
    @Binding var selectedTab: Int
    @State private var isButtonGlowing = false

    enum Field: Hashable {
        case fermentationTime, fermentationTemp
    }

    var body: some View {
        Form {
                Section("Yeast Type") {
                    Picker("Yeast Type", selection: $calculatorData.bakersYeastType) {
                        ForEach(CalculatorData.BakersYeastType.allCases, id: \.self) { yeastType in
                            Text(yeastType.displayName).tag(yeastType)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: calculatorData.bakersYeastType) { _ in
                        calculatorData.saveToDefaults()
                    }
                }

                Section("Time-Based Calculation") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter desired fermentation time and temperature to get yeast recommendation")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)

                        HStack {
                            Text("Fermentation Time")
                            Spacer()
                            AutoSelectTextField(
                                value: $calculatorData.desiredFermentationTime,
                                format: .number.precision(.fractionLength(1)),
                                placeholder: "Time",
                                onFocusChange: { isFocused in
                                    focusedField = isFocused ? .fermentationTime : nil
                                }
                            )
                            .frame(width: 80)
                            Text("h")
                                .foregroundColor(.secondary)
                        }

                        HStack {
                            Text("Temperature")
                            Spacer()
                            AutoSelectTextField(
                                value: Binding(
                                    get: {
                                        if calculatorData.useCelsius {
                                            return calculatorData.desiredFermentationTemp
                                        } else {
                                            return calculatorData.desiredFermentationTemp * 9/5 + 32
                                        }
                                    },
                                    set: { newValue in
                                        if calculatorData.useCelsius {
                                            calculatorData.desiredFermentationTemp = newValue
                                        } else {
                                            calculatorData.desiredFermentationTemp = (newValue - 32) * 5/9
                                        }
                                    }
                                ),
                                format: .number.precision(.fractionLength(1)),
                                placeholder: "Temp",
                                onFocusChange: { isFocused in
                                    focusedField = isFocused ? .fermentationTemp : nil
                                }
                            )
                            .frame(width: 80)
                            Text(calculatorData.useCelsius ? "°C" : "°F")
                                .foregroundColor(.secondary)
                        }

                        if let baseRecommendedYeast = calculatorData.recommendedYeastPercentage {
                            let convertedYeast = calculatorData.convertYeastAmount(from: .activeDry, to: calculatorData.bakersYeastType, amount: baseRecommendedYeast)

                            Divider()
                                .padding(.vertical, 4)

                            HStack {
                                Text("Recommended Yeast:")
                                    .font(.headline)
                                Spacer()
                                HStack(spacing: 4) {
                                    Text(String(format: "%.3f", convertedYeast))
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    Text("% \(calculatorData.bakersYeastType.rawValue.uppercased())")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Button("Use this amount") {
                                // Haptic feedback
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()

                                // Glow animation
                                isButtonGlowing = true

                                // Apply calculation with converted yeast amount
                                focusedField = nil
                                calculatorData.bakersYeastPercentage = convertedYeast
                                calculatorData.saveToDefaults()

                                // Sync to watch
                                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)

                                // Navigate to Recipe tab after brief delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedTab = 1
                                    }
                                    isButtonGlowing = false
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.borderedProminent)
                            .scaleEffect(isButtonGlowing ? 1.05 : 1.0)
                            .shadow(color: isButtonGlowing ? .blue : .clear, radius: isButtonGlowing ? 8 : 0)
                            .animation(.easeInOut(duration: 0.3), value: isButtonGlowing)
                        }
                    }
                }

                Section("Calculated Amount") {
                    HStack {
                        Text("Baker's Yeast Amount")
                            .font(.headline)
                        Spacer()
                        HStack(spacing: 4) {
                            Text(String(format: "%.2f", calculatorData.bakersYeastAmount))
                                .font(.title2)
                                .foregroundColor(.primary)
                            Text(calculatorData.useOunces ? "oz" : "g")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

            }
            .navigationTitle("Baker's Yeast")
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = nil
                    }
            )
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .onChange(of: calculatorData.desiredFermentationTime) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.desiredFermentationTemp) { _ in calculatorData.saveToDefaults() }
    }
}


#Preview {
    BakersYeastView(selectedTab: .constant(0))
        .environmentObject(CalculatorData())
}