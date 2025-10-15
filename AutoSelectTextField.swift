//
//  AutoSelectTextField.swift
//  zaCalc2
//
//  Created by sholl on 9/29/25.
//

import SwiftUI
import UIKit
import Foundation

struct AutoSelectTextField: UIViewRepresentable {
    @Binding var value: Double
    let format: FloatingPointFormatStyle<Double>
    let placeholder: String
    var onFocusChange: ((Bool) -> Void)?

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = .decimalPad
        textField.textAlignment = .right
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged), for: .editingChanged)

        // Add toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))
        toolbar.items = [flexSpace, doneButton]
        textField.inputAccessoryView = toolbar

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        // Don't update the text while the user is editing
        if !uiView.isFirstResponder {
            uiView.text = format.format(value)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: AutoSelectTextField

        init(_ parent: AutoSelectTextField) {
            self.parent = parent
        }

        @objc func textChanged(_ textField: UITextField) {
            if let text = textField.text, let newValue = Double(text) {
                parent.value = newValue
            }
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            // Auto-select all text when field gains focus
            DispatchQueue.main.async {
                textField.selectAll(nil)
            }
            // Also try immediate selection as backup
            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
            parent.onFocusChange?(true)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            // Format the text field with the proper format when editing ends
            textField.text = parent.format.format(parent.value)
            parent.onFocusChange?(false)
        }

        @objc func doneButtonTapped() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}