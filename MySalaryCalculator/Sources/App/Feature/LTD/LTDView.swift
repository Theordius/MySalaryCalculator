//
//  LTDView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: LTDFeature.self)
struct LTDView: View {
    // MARK: - Properties:
    @Bindable var store: StoreOf<LTDFeature>

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Choose your employment form")
                        .font(.subheadline)

                    Picker("Salary form", selection: $store.employmentForm.sending(\.view.employmentFormChanged)) {
                        ForEach(EmploymentForm.allCases, id: \.self) { form in
                            Text(form.description)
                                .tag(form)
                        }
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Form {
                    Section(header: Text("Gross value")) {
                        TextField(
                            "Gross",
                            value: $store.grossAmount.sending(\.view.grossChanged),
                            format: .number
                        )
                        .keyboardType(.decimalPad)
                    }

                    Section(header: Text("Income costs")) {
                        TextField(
                            "KUP",
                            value: $store.costOfRevenue.sending(\.view.costChanged),
                            format: .number
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

                    if let net = store.netAmount {
                        Section(header: Text("To account")) {
                            Text(net.formatted(.currency(code: "PLN")))
                                .font(.title2)
                                .bold()
                        }
                    }
                }
                .animation(.default, value: store.netAmount)
            }
            .navigationTitle("LTD")
        }
    }
}

#Preview {
    LTDView(
        store: Store(
            initialState: LTDFeature.State(),
            reducer: { LTDFeature() }
        )
    )
}


