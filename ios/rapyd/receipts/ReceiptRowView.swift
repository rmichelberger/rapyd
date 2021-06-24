//
//  ReceiptRowView.swift
//  rapyd
//
//  Created by Roland Michelberger on 18.06.21.
//

import SwiftUI

struct ReceiptRowView: View {
    
    let checkout: Checkout
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct ReceiptRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptRowView(checkout: Checkout(id: "", cancel_url: URL(string: "")!, complete_url: URL(string: "")!, merchant_logo: URL(string: "")!, amount: 0, currency: "", payment: Checkout.Payment(description: ""), cart_items: nil, timestamp: 0))
    }
}
#endif
