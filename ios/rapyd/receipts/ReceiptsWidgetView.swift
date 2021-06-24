//
//  ReceiptsWidgetView.swift
//  rapyd
//
//  Created by Roland Michelberger on 18.06.21.
//

import SwiftUI

struct ReceiptsWidgetView: View {
    
    @ObservedObject var viewModel: CheckoutViewModel
    
    var body: some View {
        VStack {
            if let checkout = viewModel.completedCheckouts.first {
                HStack {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Receipts")
                                .font(.callout)
                            Spacer()
                            NavigationLink("See all", destination: LazyView(ReceiptListView(viewModel: viewModel)))
                                .isDetailLink(isIpad)
                        }
                        .padding(.bottom, 4)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(checkout.money.fomattedString)
                                    .font(.title)
                                Text(checkout.formattedDate)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            ImageView(url: checkout.merchant_logo) {
                                ProgressView()
                            }
                            .frame(maxWidth: 60, maxHeight: 30)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.yellow.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            } else if viewModel.isLoading {
                HStack {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text("Receipts")
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
                .background(Color.yellow.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            else {
                EmptyView()
            }
        }
        .onAppear {
            viewModel.loadCompletedCheckouts()
        }
    }
}


struct ReceiptsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptsWidgetView(viewModel: CheckoutViewModel())
    }
}
