//
//  View.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

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
