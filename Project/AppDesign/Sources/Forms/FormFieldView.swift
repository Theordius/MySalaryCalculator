//
//  FormFieldView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 18/04/2025.
//


// FormFieldView.swift

import SwiftUI

struct FormFieldView: View {
    // MARK: - Properties
    @Binding var text: String
    @FocusState.Binding var focusedField: SalaryFormView.Field?
    @State private var lastFormatted: String = ""

    let title: LocalizedStringKey
    let placeholder: String
    let field: SalaryFormView.Field
    let error: String?
    let formatter: ((String) -> (String, Decimal?))?
    let onChange: (Decimal?) -> Void

    // MARK: - Body
    var body: some View {
        FormInput(
            text: $text,
            title: title,
            placeholder: placeholder,
            error: error
        )
        .focused($focusedField, equals: field)
        .keyboardType(.decimalPad)
        .onChange(of: text) { newValue in
            guard let formatter else { return onChange(nil) }

            let (formatted, value) = formatter(newValue)
            if formatted != lastFormatted {
                text = formatted
                lastFormatted = formatted
            }
            onChange(value)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var text = "15000"
        @FocusState var focus: SalaryFormView.Field?

        var body: some View {
            FormFieldView(
                text: $text,
                focusedField: $focus,
                title: "Wartość",
                placeholder: "Podaj kwotę",
                field: .gross,
                error: "Nieprawidłowa wartość",
                formatter: { input in
                    let cleaned = input
                        .replacingOccurrences(of: " ", with: "")
                        .replacingOccurrences(of: "zł", with: "")
                        .replacingOccurrences(of: ",", with: ".")

                    let decimal = Decimal(string: cleaned)
                    return (decimal?.chunkedCurrency() ?? input, decimal)
                },
                onChange: { _ in }
            )
            .padding()
        }
    }
    return PreviewWrapper()
}
