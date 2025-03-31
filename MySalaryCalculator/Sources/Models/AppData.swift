//
//  AppData.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 31/03/2025.
//

import SwiftUI

final class AppData: ObservableObject {
    @AppStorage("language") var language = "pl"
}
