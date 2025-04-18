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
        case .llc:
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
            HStack(spacing: 8) {
                ForEach(AppFeature.Tab.allCases, id: \.self) { tab in
                    tabBarButton(title: tab.title, systemImage: tab.systemImage, tab: tab)
                        .frame(maxWidth: .infinity)
                }
            }
            .dynamicTypeSize(.medium)
            .frame(height: 64)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Material.ultraThin)
            .cornerRadius(20)
            .tabBarShadow()
        }

        ToolbarItem(placement: .topBarTrailing) {
            LanguageOptionsMenuView()
        }
    }

    private func tabBarButton(
        title: LocalizedStringKey,
        systemImage: String,
        tab: AppFeature.Tab
    ) -> some View {
        Button {
            send(.changeTab(tab))
        } label: {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .frame(width: 24, height: 24)
                Text(title)
                    .lineLimit(1)
                    .font(.footnote)
            }
            .tint(store.selectedTab == tab ? .accentColor : .secondary)
        }
        .dynamicTypeSize(.medium)
    }
}

extension AppFeature.Tab {
    var title: LocalizedStringKey {
        switch self {
        case .about: "About"
        case .llc: "LLC"
        case .b2b: "B2B"
        case .fte: "FTE"
        }
    }

    var systemImage: String {
        switch self {
        case .about: "info.circle"
        case .llc: "building.2"
        case .b2b: "briefcase"
        case .fte: "person.crop.circle"
        }
    }

    func isSelected(_ selectedTab: AppFeature.Tab) -> Bool {
           self == selectedTab
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
        .environmentObject(AppData())
    }
}
