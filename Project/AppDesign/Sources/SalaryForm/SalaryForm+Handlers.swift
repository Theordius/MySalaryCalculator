//
//  SalaryForm+Handlers.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 18/04/2025.
//

import ComposableArchitecture
import SwiftUI

extension SalaryFormFeature {
    // MARK: - Intent Handlers

    func handleAppeared(_ state: inout State) -> Effect<Action> {
        state.grossAmount = 0
        state.costOfRevenue = 0
        state.netAmount = nil
        return .none
    }

    func handleGrossChanged(_ value: Decimal, _ state: inout State) -> Effect<Action> {
        state.grossAmount = value
        return .none
    }

    func handleCostChanged(_ value: Decimal, _ state: inout State) -> Effect<Action> {
        state.costOfRevenue = value
        return .none
    }

    func handleFlatTaxToggle(_ isOn: Bool, _ state: inout State) -> Effect<Action> {
        state.flatTaxSelected = isOn
        return .none
    }

    func handleEmploymentFormChange(_ form: EmploymentForm, _ state: inout State) -> Effect<Action> {
        state.employmentForm = form
        updateFlags(for: form, in: &state)
        return .none
    }

    func handleSecondTaxBracketToggle(_ isOn: Bool, _ state: inout State) -> Effect<Action> {
        state.useSecondTaxBracket = isOn
        return .none
    }

    func handleCalculate(_ state: inout State) -> Effect<Action> {
        state.netAmount = calculateNet(for: state)
        return .none
    }
}
