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
    @State private var showForm: Bool = false
    @State private var showAlert: Bool = false
    
    let store: StoreOf<LTDFeature>

    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                ZStack {
                    VStack(spacing: 16) {
                        Text("Wybierz formę rozliczania")
                            .font(.title2)
                            .padding()

                        VStack(spacing: 12) {
                            ForEach([EmploymentForm.appointment, .dividend, .fte], id: \.self) { form in
                                Button(action: {
                                    viewStore.send(.child(.form(.view(.employmentFormChanged(form)))))
                                    withAnimation(.easeInOut) {
                                        showForm = true
                                    }
                                }) {
                                    Text(form.description)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal)
                            }
                            Spacer()
                        }
                    }
                    .blur(radius: showAlert ? 10 : 0)
                }
                .fullScreenCover(isPresented: $showForm) {
                    SalaryFormView(
                        store: store.scope(
                            state: \.form,
                            action: \.child.form
                        )
                    )
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: showForm)
                }
                .onChange(of: viewStore.form.netAmount) { newValue in
                    if newValue != nil {
                        withAnimation(.easeInOut) {
                            showForm = false
                        }
                        Task {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            withAnimation(.easeInOut) {
                                showAlert = true
                            }
                        }
                    }
                }
                .alert("Na konto otrzymasz", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {
                        withAnimation(.easeInOut) {
                            showAlert = false
                        }
                    }
                } message: {
                    Text(CurrencyFormatter().string(from: viewStore.form.netAmount ?? 0))
                }
                .navigationTitle("LTD")
            }
        }
    }
}

#Preview {
    LTDView(
        store: Store(
            initialState: LTDFeature.State(),
            reducer: { LTDFeature() }
        )
    )
    .environmentObject(AppData())
}
