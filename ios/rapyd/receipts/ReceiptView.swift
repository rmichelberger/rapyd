//
//  ReceiptView.swift
//  rapyd
//
//  Created by Roland Michelberger on 21.06.21.
//

import SwiftUI

struct ReceiptView: View {
    
    let checkout: Checkout
    
    @ObservedObject private var paymentViewModel = PaymentViewModel()
    
    @ViewBuilder
    private func actionView(for checkout: Checkout) -> some View {
        if checkout.contains(text: "flight")  {
            NavigationLink("Need a travel insurance?", destination: LazyView(ActionView(actionType: .insurance)))
                .padding(.top, 2)
                .padding(.leading, 26)
        } else if checkout.contains(text: "apple")  {
            NavigationLink("Extend warranty?", destination: LazyView(ActionView(actionType: .warranty(price: checkout.money))))
                .padding(.top, 2)
                .padding(.leading, 26)
        }
        
        else {
            EmptyView()
        }
    }

    
    @ViewBuilder
    private func cartView(products: [Product], currency: String) -> some View {
        VStack {
            HStack {
                Text("Cart")
                    .font(.title2)
                Spacer()
            }
            .padding(.horizontal)
            
            VStack {
                ForEach(products) { product in
                    HStack {
                        if let image = product.image, let url = URL(string: image) {
                            ImageView(url: url) {
                                ProgressView()
                            }
                            .frame(maxWidth: 40, maxHeight: 40)
                            
                        }
                        Text(product.name)

                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Amount: \(product.quantity)")
                            Text("Price: \(Money(amount: product.amount, currency: currency).fomattedString)")
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                }
            }
            .background(Color.secondary.opacity(0.3))
        }
    }
    
    var body: some View {
        PaddedScrollView {
            ImageView(url: checkout.merchant_logo) {
                ProgressView()
            }
            .frame(maxWidth: 200, maxHeight: 70)
            
            if let profile = paymentViewModel.profile {
                Text(profile.name)
                    .font(.title)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            
            if let products = checkout.cart_items, products.isNotEmpty {
                cartView(products: products, currency: checkout.currency)
                    .padding(.vertical)
            }
            
            if let payment = paymentViewModel.payment {
                HStack(alignment: .firstTextBaseline) {
                    Text("Total price")
                        .font(.caption)
                    Text(payment.money.fomattedString)
                        .moneyLabelStyle()
                }
            } else {
                ProgressView()
            }
            
            Text(checkout.formattedDate)
                .foregroundColor(.secondary)
                .padding()
            
            
            actionView(for: checkout)
        }
        .navigationTitle("Receipt")
        .onAppear {
            // get payment profile
            let id = checkout.payment.id
            paymentViewModel.getPayment(id: id)
        }
    }
}

#if DEBUG
struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptView(checkout: Checkout(id: "", cancel_url: URL(string: "")!, complete_url: URL(string: "")!, merchant_logo: URL(string: "")!, amount: 0, currency: "", payment: Checkout.Payment(description: ""), cart_items: nil, timestamp: 0))
    }
}
#endif
