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
    let store: StoreOf<LTDFeature>

    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose settlement form")
                            .font(.subheadline)
                            .padding(.horizontal)

                        Picker("Payment form", selection: viewStore.binding(
                            get: \.form.employmentForm,
                            send: { .child(.form(.view(.employmentFormChanged($0)))) }
                        )) {
                            ForEach([EmploymentForm.appointment, .dividend, .fte], id: \.self) { form in
                                Text(form.description)
                                    .tag(form)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    }

                    if viewStore.form.employmentForm == .appointment || viewStore.form.employmentForm == .fte {
                        Toggle("Drugi Prog Podatkowy", isOn: viewStore.binding(
                            get: \.form.useSecondTaxBracket,
                            send: { .child(.form(.view(.secondTaxBracketToggled($0)))) }
                        ))
                        .padding(.horizontal)
                    }

                    SalaryFormView(
                        store: store.scope(
                            state: \.form,
                            action: \.child.form
                        )
                    )
                }
                .navigationTitle("LTD")
            }
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
    .environmentObject(AppData())
}
