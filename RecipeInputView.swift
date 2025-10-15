//
//  RecipeInputView.swift
//  zaCalc2
//
//  Created by sholl on 9/27/25.
//

import SwiftUI
import Foundation

struct RecipeInputView: View {
    @EnvironmentObject var calculatorData: CalculatorData
    @FocusState private var focusedField: Field?
    @Binding var selectedTab: Int
    @State private var isButtonGlowing = false
    @State private var showingSaveSheet = false
    @State private var showingLoadSheet = false
    @State private var recipeName = ""

    enum Field: Hashable {
        case quantity, diameter, thickness, hydration, prefermentAmount, prefermentHydration, salt, oil, sugar, waste, bakersYeastPercentage
    }

    var body: some View {
        Form {
                Section("Pizza Parameters") {
                    HStack {
                        Text("Quantity")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.quantity,
                            format: .number.precision(.fractionLength(1)),
                            placeholder: "Quantity",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .quantity : nil
                            }
                        )
                    }

                    HStack {
                        Text("Diameter")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.diameter,
                            format: .number.precision(.fractionLength(2)),
                            placeholder: "Diameter",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .diameter : nil
                            }
                        )
                        Text(calculatorData.useCentimeters ? "cm" : "inches")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Thickness")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.thickness,
                            format: .number.precision(.fractionLength(4)),
                            placeholder: "Thickness",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .thickness : nil
                            }
                        )
                        Text(calculatorData.useCentimeters ? "cm" : "inches")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Dough Properties") {
                    HStack {
                        Text("Hydration")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.hydration,
                            format: .number.precision(.fractionLength(1)),
                            placeholder: "Hydration",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .hydration : nil
                            }
                        )
                        Text("%")
                            .foregroundColor(.secondary)
                    }

                    if calculatorData.yeastType == .sourdough {
                        HStack {
                            Text("Preferment Amount")
                            Spacer()
                            AutoSelectTextField(
                                value: $calculatorData.prefermentAmount,
                                format: .number.precision(.fractionLength(2)),
                                placeholder: "Preferment",
                                onFocusChange: { isFocused in
                                    focusedField = isFocused ? .prefermentAmount : nil
                                }
                            )
                            Text("%")
                                .foregroundColor(.secondary)
                        }

                        HStack {
                            Text("Preferment Hydration")
                            Spacer()
                            AutoSelectTextField(
                                value: $calculatorData.prefermentHydration,
                                format: .number.precision(.fractionLength(0)),
                                placeholder: "Pref. Hydration",
                                onFocusChange: { isFocused in
                                    focusedField = isFocused ? .prefermentHydration : nil
                                }
                            )
                            Text("%")
                                .foregroundColor(.secondary)
                        }
                    }
                }

                if calculatorData.yeastType == .bakers {
                    Section("Baker's Yeast") {
                        HStack {
                            Text("Yeast Percentage")
                            Spacer()
                            AutoSelectTextField(
                                value: $calculatorData.bakersYeastPercentage,
                                format: .number.precision(.fractionLength(2)),
                                placeholder: "Percentage",
                                onFocusChange: { isFocused in
                                    focusedField = isFocused ? .bakersYeastPercentage : nil
                                }
                            )
                            .frame(width: 80)
                            Text("%")
                                .foregroundColor(.secondary)
                        }

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
                }

                Section("Additives") {
                    HStack {
                        Text("Salt")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.salt,
                            format: .number.precision(.fractionLength(1)),
                            placeholder: "Salt",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .salt : nil
                            }
                        )
                        Text("%")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Oil")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.oil,
                            format: .number.precision(.fractionLength(1)),
                            placeholder: "Oil",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .oil : nil
                            }
                        )
                        Text("%")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Sugar")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.sugar,
                            format: .number.precision(.fractionLength(1)),
                            placeholder: "Sugar",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .sugar : nil
                            }
                        )
                        Text("%")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Other") {
                    HStack {
                        Text("Waste")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.waste,
                            format: .number.precision(.fractionLength(1)),
                            placeholder: "Waste",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .waste : nil
                            }
                        )
                        Text("%")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Recipe Management") {
                    Button("Save Recipe") {
                        showingSaveSheet = true
                    }
                    .foregroundColor(.blue)

                    Button("Load Recipe") {
                        showingLoadSheet = true
                    }
                    .foregroundColor(.green)
                }

                Section {
                    Button("Calculate") {
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()

                        // Glow animation
                        isButtonGlowing = true

                        // UI feedback
                        focusedField = nil
                        calculatorData.saveToDefaults()

                        // Sync to watch
                        WatchConnectivityManager.shared.sendCalculatorData(calculatorData)

                        // Navigate to Results tab after brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = 2
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
            .navigationTitle("Pizza Calculator")
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
            .sheet(isPresented: $showingSaveSheet) {
                SaveRecipeSheet(recipeName: $recipeName, calculatorData: calculatorData)
            }
            .sheet(isPresented: $showingLoadSheet) {
                LoadRecipeSheet(calculatorData: calculatorData)
            }
            .onChange(of: calculatorData.quantity) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.diameter) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.thickness) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.hydration) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.prefermentAmount) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.prefermentHydration) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.salt) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.oil) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.sugar) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.waste) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .onChange(of: calculatorData.bakersYeastPercentage) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
    }
}

struct SaveRecipeSheet: View {
    @Binding var recipeName: String
    @ObservedObject var calculatorData: CalculatorData
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            Form {
                Section {
                    AutoSelectTextView(
                        text: $recipeName,
                        placeholder: "Recipe Name",
                        onFocusChange: { isFocused in
                            isTextFieldFocused = isFocused
                        }
                    )
                } header: {
                    Text("Save Current Recipe")
                } footer: {
                    Text("Enter a name for this recipe to save all current settings.")
                }
            }
            .navigationTitle("Save Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !recipeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            calculatorData.saveRecipe(name: recipeName.trimmingCharacters(in: .whitespacesAndNewlines))
                            recipeName = ""
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(.blue)
                    .disabled(recipeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isTextFieldFocused = false
                    }
                }
            }
        }
    }
}

struct LoadRecipeSheet: View {
    @ObservedObject var calculatorData: CalculatorData
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                if calculatorData.savedRecipes.isEmpty {
                    Text("No saved recipes")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(calculatorData.savedRecipes) { recipe in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(recipe.name)
                                    .font(.headline)
                                Spacer()
                                Text(recipe.yeastType.displayName)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            Text("Saved: \(recipe.dateSaved, style: .date)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            calculatorData.loadRecipe(recipe)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .onDelete(perform: deleteRecipes)
                }
            }
            .navigationTitle("Load Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func deleteRecipes(offsets: IndexSet) {
        for index in offsets {
            let recipe = calculatorData.savedRecipes[index]
            calculatorData.deleteRecipe(recipe)
        }
    }
}


#Preview {
    RecipeInputView(selectedTab: .constant(2))
        .environmentObject(CalculatorData())
}
