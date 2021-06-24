//
//  TransactionListRowView.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import SwiftUI

struct TransactionListRowView: View {
    
    @ObservedObject var viewModel: TransactionListViewModel
    
    var body: some View {
       if let transaction = viewModel.transactions.first {
            HStack {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Transactions")
                            .font(.callout)
                        Spacer()
                        NavigationLink("See all", destination: LazyView(TransactionListView(viewModel: viewModel)))
                            .isDetailLink(isIpad)
                    }
                    .padding(.bottom, 4)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.formattedAmount)
                                .font(.title)
                            Text(transaction.formattedDate)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: transaction.type == .add_funds ? "arrow.up.circle" : "arrow.left.and.right.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color.orange.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
        } else if viewModel.isLoading {
            HStack {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Transactions")
                            .font(.callout)
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    Text("")
                        .font(.title)
                    Text("")
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(Color.orange.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
       else {
            HStack {
                Spacer()
                VStack {
                    Image("empty")
                        .resizable()
                        .scaledToFit()
                        .padding(.top)
                    
                    Text("No transaction")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                }
                Spacer()
            }
            .padding(.horizontal)
            .background(Color.orange.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
        }
    }
}

#if DEBUG
struct TransactionListRowView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListRowView(viewModel: TransactionListViewModel())
    }
}
#endif
