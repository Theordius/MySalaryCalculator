//
//  LTDFeature.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct LTDFeature: Sendable {

    @ObservableState
    struct State: Equatable, Sendable {
        var employmentForm: EmploymentForm = .appointment
        var grossAmount: Decimal = 0
        var costOfRevenue: Decimal = 0
        var flatTaxSelected: Bool = false
        var netAmount: Decimal?

        var flatTaxEnabled: Bool {
            employmentForm == .appointment
        }
    }

    enum Action: Equatable, Sendable, ViewAction {
        case view(ViewAction)
        case child(ChildAction)

        @CasePathable
        enum ViewAction: Equatable, Sendable {
            case appeared
            case employmentFormChanged(EmploymentForm)
            case grossChanged(Decimal)
            case costChanged(Decimal)
            case flatTaxToggled(Bool)
            case calculate
        }

        @CasePathable
        enum ChildAction: Equatable, Sendable {}
    }

    init() {}

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(&state, viewAction)
            case .child:
                return .none
            }
        }
    }
}

private extension LTDFeature {
    func handleViewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
        switch action {
        case .appeared:
            return .none

        case let .employmentFormChanged(newForm):
            state.employmentForm = newForm
            return .none

        case let .grossChanged(value):
            state.grossAmount = value
            return .none

        case let .costChanged(value):
            state.costOfRevenue = value
            return .none

        case let .flatTaxToggled(enabled):
            state.flatTaxSelected = enabled
            return .none

        case .calculate:
            let base = state.grossAmount - state.costOfRevenue
            let taxRate: Decimal
            let healthInsurance: Decimal

            switch state.employmentForm {
            case .appointment:
                taxRate = 0.12
                healthInsurance = 0.09
            case .dividend:
                taxRate = 0.19
                healthInsurance = 0.0
            case .fte:
                taxRate = 0.12
                healthInsurance = 0.0775
            }
            state.netAmount = base * (1 - (taxRate + healthInsurance))
            return .none
        }
    }
}
