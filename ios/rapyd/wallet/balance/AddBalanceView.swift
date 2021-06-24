//
//  AddBalanceView.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import SwiftUI

struct AddBalanceView: View {
    
    private let balance: Balance
    
    @Environment(\.presentationMode) private var presentationMode
    
    init(balance: Balance, profile: Profile) {
        self.balance = balance
        walletViewModel = WalletViewModel(profile: profile)
    }
    
    @State private var tabIndex = 0
    @State private var money = Money(amount: 15, currency: "USD")
    
    @ObservedObject var viewModel = PaymentTypeViewModel()
    @ObservedObject var walletViewModel: WalletViewModel
    
    @State private var message = ""
    @State private var error: Error?
    @State private var isAlertShown = false
    
    @ViewBuilder
    private var cardView: some View {
        Button(action: {
            alert(message: "TODO: implement card scanning")
        }, label: {
            Label("Scan card", systemImage: "camera")
        })
        
        VStack(alignment: .leading) {
            Text("**** **** **** ****")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .padding(.vertical)
            Spacer()
            HStack(alignment:.lastTextBaseline) {
                VStack(alignment: .leading) {
                    Text("Valid through")
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                    Text("00/00")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                }
                .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text("CVV")
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                    Text("***")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                }
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.pink]), startPoint: .topLeading, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .aspectRatio(1.6, contentMode: .fit)
        
        PrimaryButton("Pay") {
            alert(message: "TODO: implemet card payment")
        }
    }
    
    @ViewBuilder
    private var bankView: some View {
        VStack {
            ForEach(viewModel.bankPaymentTypes) { paymentType in
                paymetTypeRow(paymentType: paymentType)
            }
        }
    }
    
    
    @ViewBuilder
    private var cashView: some View {
        VStack {
            ForEach(viewModel.cashPaymentTypes) { paymentType in
                paymetTypeRow(paymentType: paymentType)
            }
        }
    }
    
    private func alert(message: String) {
        self.message = message
        isAlertShown = true
    }
    
    @ViewBuilder
    private func paymetTypeRow(paymentType: PaymentType) -> some View {
        Button {
            alert(message: "TODO: implemet \(paymentType.name) payment")
        } label: {
            HStack {
                ImageView(url: paymentType.image) {
                    Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .topLeading, endPoint: .bottom))
                }
                .frame(width: 50, height: 50)
                
                Text(paymentType.name)
                Spacer()
                ForEach(paymentType.currencies, id: \.self) {
                    currency in
                    Text(currency)
                }
            }
        }
    }
    
    var body: some View {
        PaddedScrollView {
            VStack {
                if viewModel.isLoading || walletViewModel.isLoading {
                    ProgressView()
                } else {
                    MoneyFieldView(money: $money)
                        .padding(.vertical)
                    
                    Picker("Type", selection: $tabIndex) {
                        Text("Card")
                            .tag(0)
                        if viewModel.bankPaymentTypes.isNotEmpty {
                            Text("Bank transfer")
                                .tag(1)
                        }
                        if viewModel.cashPaymentTypes.isNotEmpty {
                            Text("Cash")
                                .tag(2)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if tabIndex == 0 {
                        cardView
                            .padding()
                    } else if tabIndex == 1 {
                        bankView
                    } else {
                        cashView
                    }
                    
                    Spacer()
                    
                }
            }
        }
        .navigationTitle("Add money")
        .padding(.horizontal)
        .alert(isPresented: $isAlertShown) {
            if message.isNotEmpty {                
                return Alert(title: Text("Top up \(money.fomattedString)"), message: Text(message), primaryButton: .cancel(), secondaryButton: .default(Text("Make test payment"), action: {
                    message = ""
                    error = nil
                    walletViewModel.addFund(money: money) { error in
                        if let error = error {
                            self.error = error
                        }
                        isAlertShown = true
                    }
                }))
            } else if let _ = error {
                return Alert(title: Text("Ooops"), message: Text("Payment failed. Please try with another currency."), dismissButton: .default(Text("Ok")))
            } else {
                return Alert(title: Text("💸🤑"), message: Text("Payment done"), dismissButton: .default(Text("Ok"), action: {
                    presentationMode.wrappedValue.dismiss()
                }))
            }
        }
        
    }
}

#if DEBUG
struct AddBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddBalanceView(balance: Balance(id: "", currency: "USD", balance: 0, alias: ""), profile: .empty)
        }
    }
}
#endif
