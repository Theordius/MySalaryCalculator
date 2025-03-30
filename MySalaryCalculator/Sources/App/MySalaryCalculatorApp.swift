//
//  MySalaryCalculatorApp.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI

@main
struct MySalaryCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: .init(initialState: .init(), reducer: { AppFeature() }))
        }
    }
}
