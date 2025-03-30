//
//  About.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI

struct About: Identifiable, Equatable, Sendable {
    var id: String
    let text: String
}
extension Array where Element == About {
    static let appInformation: [About] = [
        .init(
            id: UUID().uuidString,
            text: """
            **MySalaryCalculator** to prosty kalkulator do wyliczania wpływów na konto.
            
            Na podstawie wprowadzonej kwoty, kalkulator wylicza wartość środków, która wpłynie na konto
            
            **Obsługuje następujące warianty:**

            - Spółka z o.o.
            - B2B
            - FTE (Umowa o pracę)
            """
        )
    ]
}
