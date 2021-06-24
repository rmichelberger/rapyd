//
//  MoneyFieldView.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import SwiftUI

struct MoneyFieldView: View {
    
    @Binding var money: Money
    
    @State private var amount = ""
    
    
    var body: some View {
        //        HStack {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            NavigationLink("Choose currency", destination: CurrencyPickerView(currency: $money.currency))
            Spacer()
            Text(money.currency)
                .padding(.trailing, 8)
            
            TextField("0.00", text: Binding<String>(get: { amount }, set: { (text) in
                amount = text
                money.amount = Double(amount) ?? 0
                print(money.amount)
            }))
            .font(.title)
            .keyboardType(.decimalPad)
            .background(Color.secondary.opacity(0.5))
            .frame(maxWidth: 150)
        }.onAppear {
            amount = "\(money.amount)"
        }
    }
}

#if DEBUG
struct MoneyFieldView_Previews: PreviewProvider {
    static var previews: some View {
        MoneyFieldView(money: .constant(.empty))
    }
}
#endif
