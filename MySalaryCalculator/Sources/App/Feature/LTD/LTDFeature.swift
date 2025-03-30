//
//  LTDFeature.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import ComposableArchitecture

@Reducer
struct LTDFeature: Sendable {
    @ObservableState
    struct State: Equatable, Sendable {
        var form: SalaryFormFeature.State = .init(
            showFlatTaxToggle: false,
            showHealthContribution: true,
            employmentForm: .appointment
        )
    }

    enum Action: Equatable, Sendable, ViewAction {
        case view(ViewAction)
        case child(ChildAction)

        @CasePathable
        enum ViewAction: Equatable, Sendable {
            case appeared
        }

        @CasePathable
        enum ChildAction: Equatable, Sendable {
            case form(SalaryFormFeature.Action)
            case employmentFormChanged(EmploymentForm)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            .none
        }
        Scope(state: \.form, action: \.child.form, child: { SalaryFormFeature() })
    }
}
