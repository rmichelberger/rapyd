//
//  CheckoutView.swift
//  rapyd
//
//  Created by Roland Michelberger on 09.06.21.
//

import SwiftUI

struct CheckoutView: View {
    
    let checkoutId: String
    let profile: Profile
    @ObservedObject var viewModel: CheckoutViewModel
    @ObservedObject var paymentViewModel: PaymentViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    
    @ViewBuilder
    private func cartView(products: [Product], currency: String) -> some View {
        HStack {
            Text("Cart")
                .font(.title2)
            Spacer()
        }
        ScrollView {
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
                .padding(8)
            }
        }.frame(maxHeight: 200)
        .padding(.bottom)
        .background(Color.secondary.opacity(0.3))
    }
    
    @ViewBuilder
    private func paymentView(payment: Payment, checkout: Checkout) -> some View {
        Text("Total price")
            .font(.caption)
        Text(payment.money.fomattedString)
            .moneyLabelStyle()
        
        Spacer()
        
        if payment.paid ?? false {
            Text("Payment successful.")
                .foregroundColor(.green)
                .padding()
                .font(.system(size: 20, weight: .black, design: .default))
            
            PrimaryButton("Close") {
                URLHandler.shared.checkoutFinished(id: checkoutId)
                viewModel.complete(checkout: checkout)
                UIApplication.shared.open(checkout.complete_url)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            
        } else {
            HStack {
                Button("Reject") {
                    URLHandler.shared.checkoutFinished(id: checkoutId)
                    UIApplication.shared.open(checkout.cancel_url)
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
                Spacer()
                
                PrimaryButton("Pay") {
                    paymentViewModel.move(money: payment.money, from: profile.id, to: payment.ewallet_id) { error in
                        if let error = error {
                            print(error)
                        } else {
                            paymentViewModel.completePayment(id: checkout.payment.id)
                            //                                        paymentViewModel.getPayment(id: checkout.payment.id)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading || paymentViewModel.isLoading {
                HStack {
                    Text("Checkout")
                        .font(.largeTitle)
                    Spacer()
                }
                Spacer()
                ProgressView()
                Spacer()
            } else if let checkout = viewModel.checkout {
                HStack {
                    Text("Checkout")
                        .font(.largeTitle)
                    Spacer()
                }
                ImageView(url: checkout.merchant_logo) {
                    ProgressView()
                }
                .frame(maxWidth: 200, maxHeight: 100)
                
                if let profile = paymentViewModel.profile {
                    Text(profile.name)
                        .font(.title)
                        .padding()
                }
                
                if let products = checkout.cart_items, products.isNotEmpty {
                    cartView(products: products, currency: checkout.currency)
                }
                
                if let payment = paymentViewModel.payment {
                    paymentView(payment: payment, checkout: checkout)
                    
                } else {
                    ProgressView()
                }
            } else {
                Spacer()
                Text("Couldn't load checkout")
                Spacer()
                HStack {
                    Button("Close") {
                        URLHandler.shared.checkoutFinished(id: checkoutId)
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                    PrimaryButton("Retry") {
                        viewModel.load(checkoutId: checkoutId)
                    }
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            //            Main(after: .now() + 4) {
            viewModel.load(checkoutId: checkoutId)
            //            }
        }
        .onReceive(viewModel.$checkout, perform: { checkout in
            if let id = checkout?.payment.id {
                paymentViewModel.getPayment(id: id)
            }
        })
    }
}

#if DEBUG
struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(checkoutId: "", profile: .empty, viewModel: CheckoutViewModel(), paymentViewModel: PaymentViewModel())
    }
}
#endif
