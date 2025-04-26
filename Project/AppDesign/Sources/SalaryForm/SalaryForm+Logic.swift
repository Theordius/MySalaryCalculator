//
//  SalaryForm+Logic.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 18/04/2025.
//

import SwiftUI
import ComposableArchitecture

extension SalaryFormFeature {
    func updateFlags(for form: EmploymentForm, in state: inout State) {
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

    func calculateNet(for state: State) -> Decimal {
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
            return gross - (gross * 0.19)

        case .fte:
            let pension = gross * Decimal(Constants.retirementContributionRate)
            let disability = gross * Decimal(Constants.disabilityContributionRate)
            let sickness = gross * Decimal(Constants.sicknessContributionRate)
            let socialContributions = pension + disability + sickness

            let taxableIncome = gross - socialContributions - costOfRevenue
            let taxRate = state.useSecondTaxBracket ? Constants.secondTaxRate : Constants.firstTaxRate
            let tax = taxableIncome * Decimal(taxRate)
            let netTax = max(tax - 300, 0)
            let health = gross * Decimal(Constants.healthInsuranceRate)

            return gross - (socialContributions + netTax + health)

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
