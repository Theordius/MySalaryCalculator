//
//  FormInput.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 26/04/2025.
//

// FormInput.swift

import SwiftUI

struct FormInput: View {
    // MARK: - Properties:
    @Binding var text: String

    let title: LocalizedStringKey
    let placeholder: String
    let error: String?

    //MARK: - Body:
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)

            TextField(placeholder, text: $text)
                .textContentType(.none)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            if let error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    FormInput(
        text: .constant("Example sdsa"),
        title: "Title",
        placeholder: "Enter something",
        error: "Validation error"
    )
    .padding()
}
