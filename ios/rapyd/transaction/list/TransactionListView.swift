//
//  TransactionListView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct TransactionListView: View {
    
    @ObservedObject var viewModel: TransactionListViewModel
    
    var body: some View {
        List(viewModel.transactions) { transaction in
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(transaction.formattedAmount)
                        .font(.title)
                        .foregroundColor(transaction.amount > 0 ? .primary : .pink)
                    Text(transaction.formattedDate)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Image(systemName: transaction.type == .add_funds ? "arrow.up.circle" : "arrow.left.and.right.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    
                    Text(transaction.status.rawValue.capitalized)
                        .foregroundColor(transaction.status == .CLOSED ? .green : .orange)
                }
            }
            //                Spacer()
            //            }
            //            .padding()
            //            .background(Color.pink.opacity(0.4))
            //            .clipShape(RoundedRectangle(cornerRadius: 12))
            
        }
        .navigationTitle("Transactions")
    }
}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(viewModel: TransactionListViewModel())
    }
}
#endif
