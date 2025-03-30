//
//  Binding.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI

extension Binding where Value == Decimal {

    func asStringBinding() -> Binding<String> {
        Binding<String>(
            get: {
                self.wrappedValue == 0 ? "" : "\(self.wrappedValue)"
            },
            set: { newValue in
                if newValue.isEmpty {
                    self.wrappedValue = 0
                } else if let decimalValue = Decimal(string: newValue) {
                    self.wrappedValue = decimalValue
                }
            }
        )
    }
}
