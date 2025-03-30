//
//  LTDView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: LTDFeature.self)
struct LTDView: View {
    //MARK: - Properties:
    var store: StoreOf<LTDFeature>

    init(
        store: StoreOf<LTDFeature>
    ) {
        self.store = store
    }

    var body: some View {
        Text("FTE View")
    }
}

#Preview {
    LTDView(
        store: Store(
            initialState: LTDFeature.State(),
            reducer: { LTDFeature() }
        )
    )
}


