//
//  LanguageOptionsMenuView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 31/03/2025.
//

import Foundation
import SwiftUI

struct LanguageOptionsMenuView: View {

    // MARK: - Properties
    @EnvironmentObject var appData: AppData

    // MARK: - Body
    var body: some View {
        languageMenu()
    }

    //MARK: - Private functions:

    @ViewBuilder
    private func languageMenu() -> some View {
        Menu {
            Button("English") {
                appData.language = "en"
            }

            Button("Polish") {
                appData.language = "pl"
            }
        } label : {
            Image(systemName: "gearshape.fill")
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    LanguageOptionsMenuView()
        .environmentObject(AppData())
}
