//
//  SalaryFormView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SalaryFormView

@ViewAction(for: SalaryFormFeature.self)
struct SalaryFormView: View {

    // MARK: - Field Enum

    enum Field: Hashable {
        case gross
    }

    // MARK: - Properties

    @FocusState private var focusedField: Field?
    @State private var grossText: String = ""
    @State private var selectedRevenueOption: RevenueOption = .zero

    private let currencyFormatter = CurrencyFormatter()
    let store: StoreOf<SalaryFormFeature>

    // MARK: - Body

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 16) {

                    // MARK: - Gross Field

                    FormFieldView(
                        text: $grossText,
                        focused: $focusedField,
                        title: "Kwota brutto",
                        placeholder: "np. 12000",
                        field: .gross
                    ) { value in
                        viewStore.send(.view(.grossChanged(value)))
                    }
                    .onChange(of: grossText) { newValue in
                        let value = currencyFormatter.decimal(from: newValue) ?? 0
                        viewStore.send(.view(.grossChanged(value)))
                    }

                    // MARK: - Revenue Option Picker

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Koszty uzyskania")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Picker("Koszty uzyskania", selection: $selectedRevenueOption) {
                            ForEach(RevenueOption.allCases) { option in
                                Text(option.label).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selectedRevenueOption) { newValue in
                            viewStore.send(.view(.costChanged(newValue.rawValue)))
                        }
                    }

                    // MARK: - Calculate Button

                    Button("Oblicz") {
                        viewStore.send(.view(.calculate))
                        focusedField = nil
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    // MARK: - Result

                    if let result = viewStore.netAmount {
                        Text("Do wypłaty: \(result.formatted(.currency(code: "PLN")))")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .padding(.top, 16)
                    }
                }
                .padding()
            }
            .onAppear {
                grossText = viewStore.grossAmount == 0 ? "" : "\(viewStore.grossAmount)"
                selectedRevenueOption = RevenueOption.from(raw: viewStore.costOfRevenue)
                viewStore.send(.view(.appeared))
            }
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = nil
                    }
            )
        }
    }
}
