//
//  BalanceView.swift
//  rapyd
//
//  Created by Roland Michelberger on 07.06.21.
//

import SwiftUI

struct BalanceView: View {
    
    let balance: Balance
    let profile: Profile
    
    @State private var isShowing = false
    
    private var formattedAmount: String {
        if balance.currency.isEmpty {
            return "-"
        }
        let money = Money(amount: balance.balance, currency: balance.currency)
        return money.fomattedString
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    
                    Text("Balance")
                    Text(formattedAmount)
                        .font(.system(size: 40, weight: .bold, design: Font.Design.rounded))
                }
                Spacer()
            }
            NavigationLink(
                destination: LazyView(AddBalanceView(balance: balance, profile: profile)), isActive: $isShowing,
                label: {
                    PrimaryButton("+ Add Money") {
                        isShowing = true
                    }
                    .padding(.horizontal)
                })
            
        }
        .padding()
        .background(Color.green.opacity(0.8))
        //        .background(
        //            LinearGradient(gradient: Gradient(colors: [.blue, balance.balance >= 0 ? Color.green : Color.orange]), startPoint: .topLeading, endPoint: .bottom)
        //           )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#if DEBUG
struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView(balance: Balance(id: "", currency: "", balance: 0, alias: ""), profile: .empty)
    }
}
#endif
