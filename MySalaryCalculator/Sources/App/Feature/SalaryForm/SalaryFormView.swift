//
//  SalaryFormView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: SalaryFormFeature.self)
struct SalaryFormView: View {

    enum Field: Hashable {
        case gross, revenue
    }

    // MARK: - Properties
    @FocusState private var focusedField: Field?
    @State private var grossText: String = ""
    @State private var revenueText: String = ""

    let store: StoreOf<SalaryFormFeature>

    // MARK: - Body
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section(header: Text("Gross value")) {
                    TextField("Gross", text: $grossText)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .gross)
                        .onChange(of: grossText) { newValue in
                            let value = Decimal(string: newValue) ?? 0
                            viewStore.send(.view(.grossChanged(value)))
                        }
                }

                Section(header: Text("Cost of Revenue")) {
                    TextField("Revenue", text: $revenueText)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .revenue)
                        .onChange(of: revenueText) { newValue in
                            let value = Decimal(string: newValue) ?? 0
                            viewStore.send(.view(.costChanged(value)))
                        }
                }

                Section {
                    HStack {
                        Spacer()
                        Button("Calculate") {
                            viewStore.send(.view(.calculate))
                            focusedField = nil
                        }
                        Spacer()
                    }
                }
            }
            .onAppear {
                grossText = viewStore.state.grossAmount == 0 ? "" : "\(viewStore.state.grossAmount)"
                revenueText = viewStore.state.costOfRevenue == 0 ? "" : "\(viewStore.state.costOfRevenue)"
            }
            .padding()
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
