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
    let store: StoreOf<SalaryFormFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section(header: Text("Gross value")) {
                    TextField(
                        "Gross",
                        text: viewStore.binding(
                            get: { $0.grossAmount == 0 ? "" : "\($0.grossAmount)" },
                            send: { text in
                                let value = Decimal(string: text) ?? 0
                                return .view(.grossChanged(value))
                            }
                        )
                    )
                    .keyboardType(.decimalPad)
                }

                Section(header: Text("Cost of Revenue")) {
                    TextField(
                        "Revenue",
                        text: viewStore.binding(
                            get: { $0.costOfRevenue == 0 ? "" : "\($0.costOfRevenue)" },
                            send: { text in
                                let value = Decimal(string: text) ?? 0
                                return .view(.costChanged(value))
                            }
                        )
                    )
                    .keyboardType(.decimalPad)
                }

                Section {
                    HStack {
                        Spacer()
                        Button("Calculate") {
                            send(.calculate)
                        }
                        Spacer()
                    }
                }

                if let net = viewStore.netAmount {
                    Section(header: Text("To account")) {
                        Text(net.formatted(.currency(code: "PLN")))
                            .font(.title2)
                            .bold()
                    }
                }
            }
            .animation(.default, value: viewStore.netAmount)

            .padding()
        }
    }
}
