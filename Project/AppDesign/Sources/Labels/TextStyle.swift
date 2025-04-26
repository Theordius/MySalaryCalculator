//
//  TextStyle.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI

struct TextModification {
    let substring: String
    let font: Font?
    let color: Color?
}

extension AttributedString {
    mutating func apply(modification: TextModification) {
        if let range = self.range(of: modification.substring, options: .caseInsensitive) {
            if let font = modification.font {
                self[range].font = .init(font)
            }
            if let color = modification.color {
                self[range].foregroundColor = UIColor(color)
            }
        }
    }
}

func styledAttributedString(from attributed: AttributedString) -> AttributedString {
    var styled = attributed

    styled.runs.forEach { run in
        styled[run.range].font = .system(.body, design: .default).italic()
    }

    if let range = styled.range(of: "MySalaryCalculator") {
        styled[range].font = .system(.title2, design: .rounded).bold()
        styled[range].foregroundColor = .accentColor
    }

    return styled
}
