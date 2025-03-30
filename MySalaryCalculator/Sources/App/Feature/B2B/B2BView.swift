//
//  B2BView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: B2BFeature.self)
struct B2BView: View {
    //MARK: - Properties:
    var store: StoreOf<B2BFeature>

    init(
        store: StoreOf<B2BFeature>
    ) {
        self.store = store
    }

    var body: some View {
        Text("B2B View")
    }
}

#Preview {
    B2BView(
        store: Store(
            initialState: B2BFeature.State(),
            reducer: { B2BFeature() }
        )
    )
}
