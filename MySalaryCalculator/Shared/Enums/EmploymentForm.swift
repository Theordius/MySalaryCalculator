//
//  EmploymentForm.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI

enum EmploymentForm: String, CaseIterable, Equatable, Sendable {
    case appointment, dividend, fte, b2b

    var description: LocalizedStringKey {
        switch self {
        case .appointment:
            return "Appointment"
        case .dividend:
            return "Dividend"
        case .fte:
            return "FTE"

        case .b2b:
            return "B2B"
        }
    }
}
