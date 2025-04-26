//
//  CurrencyFormatter.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 18/04/2025.
//

import Foundation

struct CurrencyFormatter {
    private let formatter: NumberFormatter

    init(
        locale: Locale = Locale(identifier: "pl_PL"),
        currencyCode: String = "PLN"
    ) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode
        numberFormatter.locale = locale
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.generatesDecimalNumbers = true
        self.formatter = numberFormatter
    }

    func string(from decimal: Decimal) -> String {
        let nsNumber = decimal as NSDecimalNumber
        return formatter.string(from: nsNumber) ?? "\(decimal)"
    }

    func decimal(from string: String) -> Decimal? {
        let cleaned = string
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "zł", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return formatter.number(from: cleaned)?.decimalValue
    }
}
