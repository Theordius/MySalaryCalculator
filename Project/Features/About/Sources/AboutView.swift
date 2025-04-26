//
//  AboutView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: AboutFeature.self)
struct AboutView: View {
    // MARK: - Properties:
    var store: StoreOf<AboutFeature>

    //MARK: - Init

    init(
        store: StoreOf<AboutFeature>
    ) {
        self.store = store
    }

    // MARK: - Body:
    var body: some View {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(store.about) { about in
                        Text(about.text)
                            .textSelection(.enabled)
                            .font(.body)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                    }
                }
                .padding(16)
            }
            .onAppear {
                send(.appeared)
            }
            .navigationTitle("About App")

    }
}

#Preview {
    AboutView(
        store: Store(
            initialState: AboutFeature.State(),
            reducer: { AboutFeature() }
        )
    )
    .environmentObject(AppData())
}


