import SwiftUI
import Foundation

struct SourdoughCalculatorView: View {
    @EnvironmentObject var calculatorData: CalculatorData
    @FocusState private var focusedField: Field?
    @Binding var selectedTab: Int
    @State private var isButtonGlowing = false

    enum Field: Hashable {
        case time1, time2, time3, time4, time5
        case temp1, temp2, temp3, temp4, temp5
        case yeastCorrection
    }

    var body: some View {
        Form(content: {
                    Section {
                        TimeTemperatureRow(
                            title: "Stage 1",
                            time: $calculatorData.time1,
                            temp: $calculatorData.temp1,
                            timeField: .time1,
                            tempField: .temp1,
                            focusedField: $focusedField,
                            useCelsius: calculatorData.useCelsius
                        )

                        TimeTemperatureRow(
                            title: "Stage 2",
                            time: $calculatorData.time2,
                            temp: $calculatorData.temp2,
                            timeField: .time2,
                            tempField: .temp2,
                            focusedField: $focusedField,
                            useCelsius: calculatorData.useCelsius
                        )

                        if calculatorData.visibleSourdoughStages >= 3 {
                            TimeTemperatureRow(
                                title: "Stage 3",
                                time: $calculatorData.time3,
                                temp: $calculatorData.temp3,
                                timeField: .time3,
                                tempField: .temp3,
                                focusedField: $focusedField,
                                useCelsius: calculatorData.useCelsius
                            )
                        }

                        if calculatorData.visibleSourdoughStages >= 4 {
                            TimeTemperatureRow(
                                title: "Stage 4",
                                time: $calculatorData.time4,
                                temp: $calculatorData.temp4,
                                timeField: .time4,
                                tempField: .temp4,
                                focusedField: $focusedField,
                                useCelsius: calculatorData.useCelsius
                            )
                        }

                        if calculatorData.visibleSourdoughStages >= 5 {
                            TimeTemperatureRow(
                                title: "Stage 5",
                                time: $calculatorData.time5,
                                temp: $calculatorData.temp5,
                                timeField: .time5,
                                tempField: .temp5,
                                focusedField: $focusedField,
                                useCelsius: calculatorData.useCelsius
                            )
                        }

                        if calculatorData.visibleSourdoughStages < 5 {
                            Button("Add Stage") {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    calculatorData.visibleSourdoughStages = min(calculatorData.visibleSourdoughStages + 1, 5)
                                }
                            }
                            .foregroundColor(.blue)
                        }
                    } header: {
                        Text("Fermentation Stages")
                    } footer: {
                        Text("Enter time (hours) and temperature for each fermentation stage. Leave time as 0 to skip a stage.")
                    }

                    Section {
                        HStack {
                            Text("Yeast Correction Factor")
                            Spacer()
                            AutoSelectTextField(
                                value: $calculatorData.yeastCorrectionFactor,
                                format: .number.precision(.fractionLength(3)),
                                placeholder: "YCF",
                                onFocusChange: { isFocused in
                                    focusedField = isFocused ? .yeastCorrection : nil
                                }
                            )
                            .frame(width: 80)
                        }
                    } header: {
                        Text("Advanced")
                    } footer: {
                        Text("Multiplier to adjust calculations for your environment/yeast. Values above 1.0 decrease proofing time, values below 1.0 increase it.")
                    }

                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Total Time:")
                                    .font(.headline)
                                Spacer()
                                Text("\(calculatorData.totalTime, specifier: "%.1f")h")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }

                            HStack {
                                Text("Calculated Sourdough:")
                                    .font(.headline)
                                Spacer()
                                Text("\(calculatorData.calculatedPrefermentAmount, specifier: "%.2f")%")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        Text("Results")
                    }

                    Section {
                        Button("Use this amount") {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()

                            // Glow animation
                            isButtonGlowing = true

                            // Apply calculation
                            focusedField = nil
                            calculatorData.prefermentAmount = calculatorData.calculatedPrefermentAmount
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
            })
            .navigationTitle("Sourdough Calculator")
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
            .onChange(of: calculatorData.time1) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.time2) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.time3) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.time4) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.time5) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.temp1) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.temp2) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.temp3) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.temp4) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.temp5) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.yeastCorrectionFactor) { _ in calculatorData.saveToDefaults() }
            .onChange(of: calculatorData.visibleSourdoughStages) { _ in calculatorData.saveToDefaults() }
    }
}

struct TimeTemperatureRow: View {
    let title: String
    @Binding var time: Double
    @Binding var temp: Double
    let timeField: SourdoughCalculatorView.Field
    let tempField: SourdoughCalculatorView.Field
    var focusedField: FocusState<SourdoughCalculatorView.Field?>.Binding
    let useCelsius: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                HStack {
                    Text("Time:")
                    Spacer()
                    AutoSelectTextField(
                        value: $time,
                        format: .number.precision(.fractionLength(1)),
                        placeholder: "Hours",
                        onFocusChange: { isFocused in
                            focusedField.wrappedValue = isFocused ? timeField : nil
                        }
                    )
                    .frame(width: 60)
                    Text("h")
                        .foregroundColor(.secondary)
                }

                Divider()
                    .frame(height: 20)

                HStack {
                    Text("Temp:")
                    Spacer()
                    AutoSelectTextField(
                        value: $temp,
                        format: .number.precision(.fractionLength(1)),
                        placeholder: "Temp",
                        onFocusChange: { isFocused in
                            focusedField.wrappedValue = isFocused ? tempField : nil
                        }
                    )
                    .frame(width: 60)
                    Text(useCelsius ? "°C" : "°F")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}


#Preview {
    SourdoughCalculatorView(selectedTab: .constant(0))
        .environmentObject(CalculatorData())
}