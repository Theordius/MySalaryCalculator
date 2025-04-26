//
//  Decimal.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 18/04/2025.
//

import Foundation
import SwiftUI

extension Decimal {
    func chunkedCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = ","
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}
