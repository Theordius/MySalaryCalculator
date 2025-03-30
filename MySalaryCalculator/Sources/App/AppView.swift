//
//  AppView.swift
//  MySalaryCalculator
//
//  Created by Rafał Gęsior on 30/03/2025.
//

import SwiftUI
import ComposableArchitecture

@MainActor
@ViewAction(for: AppFeature.self)
struct AppView: View {
    // MARK: - Properties:
    @Bindable var store: StoreOf<AppFeature>

    init(
        store: StoreOf<AppFeature>
    ) {
        self.store = store
    }

    // MARK: - Body:
    var body: some View {
        NavigationStack {
            contentForTab(store.selectedTab)
                .toolbar(content: toolbarContent)
        }
    }

    //MARK: - View Builders:
    @ViewBuilder
    private func contentForTab(_ tab: AppFeature.Tab) -> some View {
        switch tab {
        case .about:
            AboutView(
                store: store.scope(
                    state: \.aboutState,
                    action: \.child.about
                )
            )
        case .ltd:
            LTDView(
                store: store.scope(
                    state: \.ltdState,
                    action: \.child.ltd
                )
            )
        case .b2b:
            B2BView(
                store: store.scope(
                    state: \.b2bState,
                    action: \.child.b2b
                )
            )
        case .fte:
            FTEView(
                store: store.scope(
                    state: \.fteState,
                    action: \.child.fte
                )
            )
        }
    }
}

private extension AppView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            HStack(spacing: 16) {
                tabBarButton(title: "About", systemImage: "info.circle", tab: .about)
                tabBarButton(title: "LTD", systemImage: "building.2", tab: .ltd)
                tabBarButton(title: "B2B", systemImage: "briefcase", tab: .b2b)
                tabBarButton(title: "FTE", systemImage: "person.crop.circle", tab: .fte)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 4)
            .background(Material.ultraThickMaterial)
            .cornerRadius(20)
            .tabBarShadow()
        }
    }

    private func tabBarButton(title: String, systemImage: String, tab: AppFeature.Tab) -> some View {
        Button {
            send(.changeTab(tab))
        } label: {
            VStack {
                Image(systemName: systemImage)
                Text(title)
                    .font(.caption)
            }
            .tint(store.selectedTab == tab ? .accentColor : .secondary)
        }
    }
}

#Preview {
    NavigationStack {
        AppView(
            store: Store(
                initialState: .init(),
                reducer: { AppFeature() }
            )
        )
    }
}
