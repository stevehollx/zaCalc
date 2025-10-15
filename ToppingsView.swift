//
//  ToppingsView.swift
//  zaCalc2
//
//  Created by sholl on 9/27/25.
//

import SwiftUI
import Foundation

struct ToppingsView: View {
    @EnvironmentObject var calculatorData: CalculatorData
    @State private var showingStyleEditor = false
    @State private var selectedStyle: CalculatorData.CustomPizzaStyle?
    @State private var showingRestoreAlert = false
    @State private var showingStylePicker = false
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case toppingsSize
    }

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
        List {
                Section("Pizza Size") {
                    HStack {
                        Text("Diameter")
                        Spacer()
                        AutoSelectTextField(
                            value: $calculatorData.toppingsSize,
                            format: .number.precision(.fractionLength(1)),
                            placeholder: "Size",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .toppingsSize : nil
                            }
                        )
                        .frame(width: 80)
                        Text("in")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Pizza Style") {
                    Button {
                        showingStylePicker = true
                    } label: {
                        HStack {
                            Text("Pizza Style")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(currentStyle?.name ?? "No Style")
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }

                if let style = currentStyle {
                    Section {
                        ForEach(style.toppings) { topping in
                            ToppingRow(
                                topping: topping,
                                scaledAmount: topping.amount * scalingFactor
                            )
                        }
                    } header: {
                        Text("Calculated Toppings")
                    } footer: {
                        Text("Weights are per pizza. Scaled from \(String(format: "%.1f", style.referenceSize))\" to \(String(format: "%.1f", calculatorData.toppingsSize))\" pizza.")
                    }
                }
            }
            .navigationTitle("Toppings")
            .sheet(isPresented: $showingStyleEditor) {
                if let style = selectedStyle {
                    PizzaStyleEditorView(
                        style: style,
                        isNew: !calculatorData.customPizzaStyles.contains { $0.id == style.id }
                    ) { updatedStyle in
                        if calculatorData.customPizzaStyles.contains(where: { $0.id == updatedStyle.id }) {
                            calculatorData.updateCustomStyle(updatedStyle)
                        } else {
                            calculatorData.addCustomStyle(updatedStyle)
                            calculatorData.selectedCustomStyleId = updatedStyle.id
                            calculatorData.saveToDefaults()
                        }
                        selectedStyle = nil
                    }
                }
            }
            .sheet(isPresented: $showingStylePicker) {
                PizzaStylePickerView(calculatorData: calculatorData, selectedStyle: $selectedStyle, showingStyleEditor: $showingStyleEditor, showingRestoreAlert: $showingRestoreAlert)
            }
            .onChange(of: showingStylePicker) { isShowing in
                if isShowing {
                    // Sync selectedStyle with current selection when picker is about to open
                    if let currentStyleId = calculatorData.selectedCustomStyleId {
                        selectedStyle = calculatorData.customPizzaStyles.first { $0.id == currentStyleId }
                    }
                }
            }
            .onAppear {
                // Set default selection if none
                if calculatorData.selectedCustomStyleId == nil {
                    calculatorData.selectedCustomStyleId = calculatorData.customPizzaStyles.first?.id
                }

                // Pre-load the currently selected style into selectedStyle
                // This ensures the edit button works immediately for the default style
                if selectedStyle == nil, let currentStyleId = calculatorData.selectedCustomStyleId {
                    selectedStyle = calculatorData.customPizzaStyles.first { $0.id == currentStyleId }
                }
            }
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
            .onChange(of: calculatorData.toppingsSize) { _ in
                calculatorData.saveToDefaults()
                WatchConnectivityManager.shared.sendCalculatorData(calculatorData)
            }
            .alert("Restore Defaults", isPresented: $showingRestoreAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Restore", role: .destructive) {
                    calculatorData.restoreDefaultStyles()
                    calculatorData.selectedCustomStyleId = calculatorData.customPizzaStyles.first?.id
                }
            } message: {
                Text("This will restore all pizza styles to their original defaults. Any custom styles will be lost. Are you sure?")
            }
    }
}

struct ToppingRow: View {
    let topping: CalculatorData.Topping
    let scaledAmount: Double

    var body: some View {
        HStack {
            Text(topping.name)
            Spacer()
            HStack(spacing: 4) {
                Text(String(format: "%.1f", scaledAmount))
                    .font(.headline)
                Text(topping.unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PizzaStylePickerView: View {
    @ObservedObject var calculatorData: CalculatorData
    @Binding var selectedStyle: CalculatorData.CustomPizzaStyle?
    @Binding var showingStyleEditor: Bool
    @Binding var showingRestoreAlert: Bool
    @Environment(\.presentationMode) var presentationMode

    var currentlySelectedStyle: CalculatorData.CustomPizzaStyle? {
        if calculatorData.selectedCustomStyleId != nil {
            return calculatorData.customPizzaStyles.first(where: { $0.id == calculatorData.selectedCustomStyleId })
        } else {
            return calculatorData.customPizzaStyles.first
        }
    }

    func isStyleSelected(_ style: CalculatorData.CustomPizzaStyle) -> Bool {
        if calculatorData.selectedCustomStyleId == style.id {
            return true
        }
        if calculatorData.selectedCustomStyleId == nil && style.id == calculatorData.customPizzaStyles.first?.id {
            return true
        }
        return false
    }

    var body: some View {
        List {
            Section("Available Styles") {
                ForEach(calculatorData.customPizzaStyles) { style in
                    HStack {
                        Text(style.name)
                        Spacer()
                        // Show checkmark for selected style, or first style if none selected
                        if isStyleSelected(style) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        calculatorData.selectedCustomStyleId = style.id
                        calculatorData.saveToDefaults()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }

            Section("Actions") {
                Button("Add Custom Style") {
                    selectedStyle = CalculatorData.CustomPizzaStyle(name: "New Style", referenceSize: 12.0)
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showingStyleEditor = true
                    }
                }
                .foregroundColor(.blue)

                // Show edit button for currently selected style (including default first style)
                if let styleToEdit = currentlySelectedStyle {
                    Button("Edit \(styleToEdit.name)") {
                        selectedStyle = styleToEdit
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showingStyleEditor = true
                        }
                    }
                    .foregroundColor(.blue)
                }

                Button("Restore Defaults") {
                    showingRestoreAlert = true
                }
                .foregroundColor(.orange)
            }
        }
        .navigationTitle("Pizza Styles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PizzaStyleEditorView: View {
    @State private var style: CalculatorData.CustomPizzaStyle
    let isNew: Bool
    let onSave: (CalculatorData.CustomPizzaStyle) -> Void
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focusedField: StyleField?

    enum StyleField: Hashable {
        case styleName, referenceSize
        case toppingName(Int), toppingAmount(Int), toppingUnit(Int)
    }

    init(style: CalculatorData.CustomPizzaStyle, isNew: Bool, onSave: @escaping (CalculatorData.CustomPizzaStyle) -> Void) {
        self._style = State(initialValue: style)
        self.isNew = isNew
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            List {
                Section("Style Info") {
                    AutoSelectTextView(
                        text: $style.name,
                        placeholder: "Style Name",
                        onFocusChange: { isFocused in
                            focusedField = isFocused ? .styleName : nil
                        }
                    )

                    HStack {
                        Text("Reference Size")
                        Spacer()
                        AutoSelectTextField(
                            value: $style.referenceSize,
                            format: .number.precision(.fractionLength(1)),
                            placeholder: "Size",
                            onFocusChange: { isFocused in
                                focusedField = isFocused ? .referenceSize : nil
                            }
                        )
                        .frame(width: 80)
                        Text("in")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Toppings") {
                    ForEach(style.toppings.indices, id: \.self) { index in
                        ToppingEditorRow(
                            topping: $style.toppings[index],
                            focusedField: $focusedField,
                            index: index
                        )
                    }
                    .onDelete(perform: deleteToppings)

                    Button("Add Topping") {
                        style.toppings.append(CalculatorData.Topping(name: "New Topping", amount: 100, unit: "g"))
                    }
                    .foregroundColor(.green)
                }
            }
            .navigationTitle(isNew ? "New Style" : "Edit Style")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = nil
                    }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(style)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(style.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }

    private func deleteToppings(offsets: IndexSet) {
        style.toppings.remove(atOffsets: offsets)
    }
}

struct ToppingEditorRow: View {
    @Binding var topping: CalculatorData.Topping
    var focusedField: FocusState<PizzaStyleEditorView.StyleField?>.Binding
    let index: Int

    var body: some View {
        VStack(spacing: 8) {
            AutoSelectTextView(
                text: $topping.name,
                placeholder: "Topping Name",
                onFocusChange: { isFocused in
                    focusedField.wrappedValue = isFocused ? .toppingName(index) : nil
                }
            )
            .font(.headline)

            HStack {
                Text("Amount:")
                Spacer()
                AutoSelectTextField(
                    value: $topping.amount,
                    format: .number.precision(.fractionLength(1)),
                    placeholder: "Amount",
                    onFocusChange: { isFocused in
                        focusedField.wrappedValue = isFocused ? .toppingAmount(index) : nil
                    }
                )
                .frame(width: 80)

                AutoSelectTextView(
                    text: $topping.unit,
                    placeholder: "Unit",
                    onFocusChange: { isFocused in
                        focusedField.wrappedValue = isFocused ? .toppingUnit(index) : nil
                    }
                )
                .frame(width: 60)
            }
        }
        .padding(.vertical, 4)
    }
}


#Preview {
    ToppingsView()
        .environmentObject(CalculatorData())
}