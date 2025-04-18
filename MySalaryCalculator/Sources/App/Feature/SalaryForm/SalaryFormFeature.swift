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

    // MARK: - State

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

        init(
            grossAmount: Decimal = 0,
            costOfRevenue: Decimal = 0,
            flatTaxEnabled: Bool = false,
            flatTaxSelected: Bool = false,
            netAmount: Decimal? = nil,
            showFlatTaxToggle: Bool,
            showHealthContribution: Bool,
            employmentForm: EmploymentForm
        ) {
            self.grossAmount = grossAmount
            self.costOfRevenue = costOfRevenue
            self.flatTaxEnabled = flatTaxEnabled
            self.flatTaxSelected = flatTaxSelected
            self.netAmount = netAmount
            self.showFlatTaxToggle = showFlatTaxToggle
            self.showHealthContribution = showHealthContribution
            self.employmentForm = employmentForm
        }
    }

    // MARK: - Action

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

    // MARK: - Body

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

    // MARK: - Intent Handlers

    private func handleAppeared(_ state: inout State) -> Effect<Action> {
        reset(&state)
        return .none
    }

    private func handleGrossChanged(_ value: Decimal, _ state: inout State) -> Effect<Action> {
        state.grossAmount = value
        return .none
    }

    private func handleCostChanged(_ value: Decimal, _ state: inout State) -> Effect<Action> {
        state.costOfRevenue = value
        return .none
    }

    private func handleFlatTaxToggle(_ isOn: Bool, _ state: inout State) -> Effect<Action> {
        state.flatTaxSelected = isOn
        return .none
    }

    private func handleEmploymentFormChange(_ form: EmploymentForm, _ state: inout State) -> Effect<Action> {
        state.employmentForm = form
        updateFlags(for: form, in: &state)
        return .none
    }

    private func handleSecondTaxBracketToggle(_ isOn: Bool, _ state: inout State) -> Effect<Action> {
        state.useSecondTaxBracket = isOn
        return .none
    }

    private func handleCalculate(_ state: inout State) -> Effect<Action> {
        state.netAmount = calculateNet(for: state)
        return .none
    }

    // MARK: - Helpers

    private func reset(_ state: inout State) {
        state.grossAmount = 0
        state.costOfRevenue = 0
        state.netAmount = nil
    }

    private func updateFlags(for form: EmploymentForm, in state: inout State) {
        switch form {
        case .appointment:
            state.showFlatTaxToggle = false
            state.flatTaxSelected = false
            state.showHealthContribution = true

        case .dividend:
            state.showFlatTaxToggle = false
            state.flatTaxSelected = true
            state.showHealthContribution = false

        case .fte:
            state.showFlatTaxToggle = false
            state.flatTaxSelected = false
            state.showHealthContribution = true

        case .b2b:
            state.showFlatTaxToggle = true
            state.flatTaxSelected = true
            state.showHealthContribution = true
        }
    }

    private func calculateNet(for state: State) -> Decimal {
        let gross = state.grossAmount
        let costOfRevenue = state.costOfRevenue
        let income = gross - costOfRevenue

        switch state.employmentForm {
        case .appointment:
            let health = gross * Decimal(Constants.healthInsuranceRate)
            let taxRate = state.useSecondTaxBracket ? Constants.secondTaxRate : Constants.firstTaxRate
            let tax = income * Decimal(taxRate)
            let taxRelief: Decimal = 300
            let totalDeductions = max(tax - taxRelief, 0) + health
            return gross - totalDeductions

        case .dividend:
            let tax = gross * 0.19
            return gross - tax

        case .fte:
            let pension = gross * Decimal(Constants.retirementContributionRate)
            let disability = gross * Decimal(Constants.disabilityContributionRate)
            let sickness = gross * Decimal(Constants.sicknessContributionRate)
            let socialContributions = pension + disability + sickness

            let taxableIncome = gross - socialContributions - costOfRevenue
            let taxRate = state.useSecondTaxBracket ? Constants.secondTaxRate : Constants.firstTaxRate
            let tax = taxableIncome * Decimal(taxRate)
            let taxRelief: Decimal = 300
            let netTax = max(tax - taxRelief, 0)

            let healthInsurance = gross * Decimal(Constants.healthInsuranceRate)
            let totalDeductions = socialContributions + netTax + healthInsurance
            return gross - totalDeductions

        case .b2b:
            let base = gross - costOfRevenue
            let tax = state.flatTaxSelected
                ? gross * Decimal(Constants.flatTaxRate)
                : base * Decimal(Constants.firstTaxRate)
            let health = state.showHealthContribution ? gross * 0.09 : 0
            return gross - (tax + health)
        }
    }
}
