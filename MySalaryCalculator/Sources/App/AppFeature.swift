//
//  AppFeature.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import ComposableArchitecture

@Reducer
struct AppFeature: Sendable {

    enum Tab: Sendable, CaseIterable, Equatable {
        case about, ltd, b2b, fte
    }

    @ObservableState
    struct State: Equatable, Sendable {
        var aboutState: AboutFeature.State
        var ltdState: LTDFeature.State
        var b2bState: B2BFeature.State
        var fteState: FTEFeature.State

        var selectedTab: Tab = .about

        init(
            aboutState: AboutFeature.State = .init(),
            ltdState: LTDFeature.State = .init(),
            b2bState: B2BFeature.State = .init(),
            fteState: FTEFeature.State = .init(),
            selectedTab: Tab = .about
        ) {
            self.aboutState = aboutState
            self.ltdState = ltdState
            self.b2bState = b2bState
            self.fteState = fteState
            self.selectedTab = selectedTab
        }
    }

    @CasePathable
    enum Action: Equatable, Sendable, ViewAction {
        case view(ViewAction)
        case child(ChildAction)

        @CasePathable
        enum ViewAction: Equatable, Sendable {
            case appeared
            case changeTab(Tab)
        }

        @CasePathable
        enum ChildAction: Equatable, Sendable {
            case about(AboutFeature.Action)
            case ltd(LTDFeature.Action)
            case b2b(B2BFeature.Action)
            case fte(FTEFeature.Action)
        }
    }

    init() {}

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(&state, viewAction)

            case .child:
                return .none
            }
        }
    }
}

private extension AppFeature {
    func handleViewAction(_ state: inout State, _ action: Action.ViewAction) -> Effect<Action> {
        switch action {
        case .appeared:
            return .none
        case let .changeTab(tab):
            state.selectedTab = tab
            return .none
        }
    }
}
