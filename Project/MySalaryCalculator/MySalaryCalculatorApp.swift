//
//  MySalaryCalculatorApp.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI

@main
struct MySalaryCalculatorApp: App {
    //MARK: - Properties:
    @StateObject var appData = AppData()

    var body: some Scene {
        WindowGroup {
            AppView(store: .init(initialState: .init(), reducer: { AppFeature() }))
                .environment(\.locale, Locale(identifier: appData.language))
                .environmentObject(appData)
        }
    }
}
