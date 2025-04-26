//
//  SalaryFormView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//


// SalaryFormView.swift

import SwiftUI
import ComposableArchitecture

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

    let store: StoreOf<SalaryFormFeature>
    private let currencyFormatter = CurrencyFormatter()

    // MARK: - Body

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 16) {
                    grossField(viewStore)
                    revenueOptionPicker(viewStore)
                    calculateButton(viewStore)
                    resultView(viewStore)
                }
                .padding()
            }
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        focusedField = nil
                    }
            )
            .onAppear {
                setupInitialValues(viewStore)
                send(.appeared)
            }
        }
    }

    // MARK: - Private Views

    @ViewBuilder
    private func grossField(_ viewStore: ViewStoreOf<SalaryFormFeature>) -> some View {
        FormFieldView(
            text: $grossText,
            focusedField: $focusedField,
            title: "Kwota brutto",
            placeholder: "np. 12000",
            field: .gross,
            error: nil,
            formatter: { input in
                let cleaned = input
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "zł", with: "")
                    .replacingOccurrences(of: ",", with: ".")

                let decimal = Decimal(string: cleaned)
                return (decimal?.chunkedCurrency() ?? input, decimal)
            }
        ) { value in
            if viewStore.grossAmount != value {
                send(.grossChanged(value ?? 0.0))
            }
        }
    }

    @ViewBuilder
    private func revenueOptionPicker(_ viewStore: ViewStoreOf<SalaryFormFeature>) -> some View {
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
                if viewStore.costOfRevenue != newValue.rawValue {
                    send(.costChanged(newValue.rawValue))
                }
            }
        }
    }

    @ViewBuilder
    private func calculateButton(_ viewStore: ViewStoreOf<SalaryFormFeature>) -> some View {
        Button("Oblicz") {
            send(.calculate)
            focusedField = nil
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func resultView(_ viewStore: ViewStoreOf<SalaryFormFeature>) -> some View {
        if let result = viewStore.netAmount {
            Text("Do wypłaty: \(CurrencyFormatter().string(from: result))")
                .font(.headline)
                .foregroundColor(.accentColor)
                .padding(.top, 16)
        }
    }

    // MARK: - Helpers

    private func setupInitialValues(_ viewStore: ViewStoreOf<SalaryFormFeature>) {
        if grossText.isEmpty || viewStore.grossAmount == 0 {
            grossText = ""
        } else {
            let formatted = currencyFormatter.string(from: viewStore.grossAmount)
            if formatted != grossText {
                grossText = formatted
            }
        }
        selectedRevenueOption = RevenueOption.from(raw: viewStore.costOfRevenue)
    }
}
