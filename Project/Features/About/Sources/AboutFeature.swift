//
//  AboutFeature.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import ComposableArchitecture

@Reducer
struct AboutFeature: Sendable {

    @ObservableState
    struct State: Equatable, Sendable {
        var about: [About]
        
        init(
            about: [About] = .appInformation
        ) {
            self.about = about
        }
    }


    enum Action: Equatable, Sendable, ViewAction {
        case view(ViewAction)

        enum ViewAction: Equatable, Sendable {
            case appeared
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.appeared):
                return .none
            }
        }
    }
}
