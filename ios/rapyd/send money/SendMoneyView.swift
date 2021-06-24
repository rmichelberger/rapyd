//
//  SendMoneyView.swift
//  rapyd
//
//  Created by Roland Michelberger on 11.06.21.
//

import SwiftUI

struct SendMoneyView: View {
    
    let profile: Profile
    
    @ObservedObject private var viewModel = PaymentViewModel()
    
    @State private var money = Money(amount: 15, currency: "USD")
    
    @State private var url: URL? = nil
    @State private var error: Error? = nil
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                MoneyFieldView(money: $money)
                    .padding()
                
                Spacer()

                Image("send_money")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Text("Create a \"Send money\" link. With this link people can easily receive money from you.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding()

                Spacer()
                
                PrimaryButton {
                    viewModel.send(money: money, walletId: profile.id) { result in
                        switch result {
                        case .failure(let error): self.error = error
                        case .success(let url): self.url = url
                        }
                    }

                } content: {
                    Label("Send money", systemImage: "arrow.forward.circle")
                }
                .padding()
            }
        }
        .padding(.bottom)
        .navigationTitle("Send money")
        .sheet(isPresented: Binding<Bool>(get: { url != nil }, set: { show in
            url = nil
        })) {
            if let url = url {
                ShareSheetView(activityItems: [url])
            } else { EmptyView() }
        }
        .alert(isPresented: Binding<Bool>(get: { error != nil }, set: { show in
            error = nil
        })) {
            Alert(title: Text("Oops"), message: Text("An error occured.\nCurrently only USD payments are supported.\nWe're working on other currencies as well, stay tuned."), dismissButton: .default(Text("Ok")))
        }
    }}

#if DEBUG
struct SendMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        SendMoneyView(profile: .empty)
    }
}
#endif
