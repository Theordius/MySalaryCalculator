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

    // MARK: - Body:
    var body: some View {
        NavigationStack {
            ScrollView {
                if let about = store.about.first {
                    if let attributed = try? AttributedString(
                        markdown: about.text,
                        options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnly)
                    ) {

                        Spacer()

                        Text(styledAttributedString(from: attributed))
                            .textSelection(.enabled)
                            .font(.body)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                    } else {
                        Text(about.text)
                            .textSelection(.enabled)
                            .padding()
                    }
                }
            }
            .navigationTitle("O Aplikacji")
        }
    }
}

#Preview {
    AboutView(
        store: Store(
            initialState: AboutFeature.State(),
            reducer: { AboutFeature() }
        )
    )
}


