//
//  SalaryForm+RevenueVariant.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 18/04/2025.
//

import SwiftUI

extension SalaryFormView {
    enum RevenueOption: Decimal, CaseIterable, Identifiable, Equatable {
        case zero = 0
        case standard = 250
        case full = 300

        var id: Decimal { rawValue }

        var rawValue: Decimal {
            switch self {
            case .zero: return 0
            case .standard: return 250
            case .full: return 300
            }
        }

        var label: String {
            switch self {
            case .zero: return "0 zł"
            case .standard: return "250 zł"
            case .full: return "300 zł"
            }
        }

        static func from(raw: Decimal) -> RevenueOption {
            self.allCases.first(where: { $0.rawValue == raw }) ?? .zero
        }
    }
}
