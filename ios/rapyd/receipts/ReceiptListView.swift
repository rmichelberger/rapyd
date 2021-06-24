//
//  ReceiptListView.swift
//  rapyd
//
//  Created by Roland Michelberger on 18.06.21.
//

import SwiftUI

struct ReceiptListView: View {
    
    @ObservedObject var viewModel: CheckoutViewModel
    
    @ViewBuilder
    private func actionView(for checkout: Checkout) -> some View {
        if checkout.contains(text: "flight") {
            NavigationLink("Need a travel insurance?", destination: LazyView(ActionView(actionType: .insurance)))
                .padding(.top, 2)
                .padding(.leading, 26)
        } else if checkout.contains(text: "apple") {
            NavigationLink("Extend warranty?", destination: LazyView(ActionView(actionType: .warranty(price: checkout.money))))
                .padding(.top, 2)
                .padding(.leading, 26)
        }
        
        else {
            EmptyView()
        }
    }
        
    private func systemImageName(checkout: Checkout) -> String {
        if checkout.contains(text: "flight") {
            return "airplane"
        }
        if checkout.contains(text: "apple") {
            return "applelogo"
        }
        return "circle.fill"
    }
    
    @ViewBuilder
    private func view(for checkout: Checkout) -> some View {
        HStack {
            Image(systemName: systemImageName(checkout: checkout))
                .foregroundColor(.primary)
                .frame(maxWidth: 20)
            VStack(alignment: .leading) {
                Text(checkout.money.fomattedString)
                    .foregroundColor(.primary)
                Text(checkout.formattedDate)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            Spacer()

            Image(systemName: "chevron.right")
            
        }
    }
    
    var body: some View {
        PaddedScrollView {
            ForEach(viewModel.completedCheckouts) { checkout in
                VStack(alignment: .leading) {
                    NavigationLink(destination: LazyView(ReceiptView(checkout: checkout))) {
                        view(for: checkout)
                    }
                    actionView(for: checkout)
                }
                .padding()
            }
        }
        .navigationTitle("Receipts")
    }
}

#if DEBUG
struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptListView(viewModel: CheckoutViewModel())
    }
}
#endif
