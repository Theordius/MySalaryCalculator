//
//  FTEView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: FTEFeature.self)
struct FTEView: View {
    //MARK: - Properties:
    var store: StoreOf<FTEFeature>

    init(
        store: StoreOf<FTEFeature>
    ) {
        self.store = store
    }

    var body: some View {
        Text("FTE View")
    }
}

#Preview {
    FTEView(
        store: Store(
            initialState: FTEFeature.State(),
            reducer: { FTEFeature() }
        )
    )
}


