//
//  FormFieldView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 18/04/2025.
//


import SwiftUI

struct FormFieldView: View {
    //MARK: - Properties
    @Binding var text: String
    @FocusState.Binding var focused: SalaryFormView.Field?
    @State private var lastFormatted: String = ""

    private let currencyFormatter = CurrencyFormatter()

    let title: String
    let placeholder: String
    let field: SalaryFormView.Field
    let onChange: (Decimal) -> Void

    //MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextField(placeholder, text: $text)
                .keyboardType(.decimalPad)
                .focused($focused, equals: field)
                .textContentType(.none)
                .accessibilityLabel(Text(title))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onChange(of: text) { newValue in
                    let cleaned = newValue
                        .replacingOccurrences(of: " ", with: "")
                        .replacingOccurrences(of: "zł", with: "")
                        .replacingOccurrences(of: ",", with: ".")

                    if let value = Decimal(string: cleaned) {
                        let formatted = value.chunkedCurrency()
                        if formatted != lastFormatted {
                            text = formatted
                            lastFormatted = formatted
                        }
                        onChange(value)
                    }
                }
        }
    }
}

//MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State var text = "15000"
        @FocusState var focus: SalaryFormView.Field?

        var body: some View {
            FormFieldView(
                text: $text,
                focused: $focus,
                title: "Wartość",
                placeholder: "",
                field: .gross,
                onChange: { _ in }
            )
        }
    }
    return PreviewWrapper()
}
