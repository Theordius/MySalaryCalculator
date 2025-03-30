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
            VStack {
                Form {
                    Section(header: Text("Wybierz formę wypłaty")) {
                        Picker("Forma wypłaty", selection: $store.employmentForm.sending(\.view.employmentFormChanged)) {
                            ForEach(EmploymentForm.allCases, id: \.self) { form in
                                Text(form.rawValue.capitalized).tag(form)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Section(header: Text("Kwota brutto")) {
                        TextField(
                            "Brutto",
                            value: $store.grossAmount.sending(\.view.grossChanged),
                            format: .number
                        )
                        .keyboardType(.decimalPad)
                    }

                    Section(header: Text("Koszty uzyskania przychodu")) {
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
                            Button("Oblicz") {
                                
                                send(.calculate)
                            }
                            Spacer()
                        }
                    }


                    if let net = store.netAmount {
                        Section(header: Text("Na konto")) {
                            Text(net.formatted(.currency(code: "PLN")))
                                .font(.title2)
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle("Spółka z o.o.")

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


