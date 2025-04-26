//
//  SalaryFormFeature.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import ComposableArchitecture
import SwiftUI


@Reducer
struct SalaryFormFeature: Sendable {
    @ObservableState
    struct State: Equatable, Sendable {
        var grossAmount: Decimal = 0
        var costOfRevenue: Decimal = 0
        var flatTaxEnabled: Bool = false
        var flatTaxSelected: Bool = false
        var netAmount: Decimal?
        var useSecondTaxBracket: Bool = false
        var showFlatTaxToggle: Bool
        var showHealthContribution: Bool
        var employmentForm: EmploymentForm
    }

    enum Action: Equatable, Sendable, ViewAction {
        case view(ViewAction)

        @CasePathable
        enum ViewAction: Equatable, Sendable {
            case appeared
            case grossChanged(Decimal)
            case costChanged(Decimal)
            case flatTaxToggled(Bool)
            case employmentFormChanged(EmploymentForm)
            case secondTaxBracketToggled(Bool)
            case calculate
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.appeared):
                return handleAppeared(&state)
            case let .view(.grossChanged(value)):
                return handleGrossChanged(value, &state)
            case let .view(.costChanged(value)):
                return handleCostChanged(value, &state)
            case let .view(.flatTaxToggled(isOn)):
                return handleFlatTaxToggle(isOn, &state)
            case let .view(.employmentFormChanged(form)):
                return handleEmploymentFormChange(form, &state)
            case let .view(.secondTaxBracketToggled(isOn)):
                return handleSecondTaxBracketToggle(isOn, &state)
            case .view(.calculate):
                return handleCalculate(&state)
            case .view:
                return .none
            }
        }
    }
}
