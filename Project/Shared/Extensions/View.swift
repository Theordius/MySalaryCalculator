//
//  View.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    func tabBarShadow() -> some View {
        compositingGroup()
        .shadow(color: .black.opacity(0.2), radius: 2.5, x: 0, y: 5)
        .shadow(color: .black.opacity(0.12), radius: 7, x: 0, y: 3)
        .shadow(color: .black.opacity(0.14), radius: 5, x: 0, y: 8)
    }
}
