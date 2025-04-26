//
//  String.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 18/04/2025.
//

import SwiftUI

extension String {
    func chunkedDecimalCurrency() -> String {
        if let decimal = Decimal(string: self.replacingOccurrences(of: ",", with: ".")) {
            return decimal.chunkedCurrency()
        }
        return self
    }
}
