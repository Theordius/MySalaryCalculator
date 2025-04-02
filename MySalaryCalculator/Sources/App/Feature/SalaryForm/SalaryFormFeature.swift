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
    
    enum Action: Equatable, Sendable, ViewAction {
        case view(ViewAction)
        
        @CasePathable
        enum ViewAction: Equatable, Sendable {
            case appeared
            case grossChanged(Decimal)
            case costChanged(Decimal)
            case flatTaxToggled(Bool)
            case employmentFormChanged(EmploymentForm)
            case calculate
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(.grossChanged(value)):
                state.grossAmount = value
                return .none
                
            case let .view(.costChanged(value)):
                state.costOfRevenue = value
                return .none
                
            case let .view(.flatTaxToggled(isOn)):
                state.flatTaxSelected = isOn
                return .none
                
            case let .view(.employmentFormChanged(newForm)):
                state.employmentForm = newForm
                updateFlags(for: newForm, in: &state)
                return .none
                
            case .view(.calculate):
                state.netAmount = calculateNet(for: state)
                return .none
                
            case .view:
                return .none
            }
        }
    }
    
    private func calculateNet(for state: State) -> Decimal {
        let gross = state.grossAmount
        let costOfRevenue = state.costOfRevenue
        let income = gross - costOfRevenue
        
        switch state.employmentForm {
        case .appointment:
            let health = gross * 0.09
            let tax = income * 0.12
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
            let tax = taxableIncome * Decimal(Constants.firstTaxRate)
            let taxRelief: Decimal = 300
            let netTax = max(tax - taxRelief, 0)
            
            let healthInsurance = gross * 0.09
            let totalDeductions = socialContributions + netTax + healthInsurance
            return gross - totalDeductions
            
        case .b2b:
            let base = gross - costOfRevenue
            let tax = state.flatTaxSelected ? gross * Decimal(Constants.flatTaxRate) : base * Decimal(Constants.firstTaxRate)
            let health = state.showHealthContribution ? gross * 0.09 : 0
            return gross - (tax + health)
        }
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
}
