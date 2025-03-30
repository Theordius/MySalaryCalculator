//
//  B2BFeature.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import ComposableArchitecture

@Reducer
struct B2BFeature: Sendable {

    @ObservableState
    struct State: Equatable, Sendable {
     
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
