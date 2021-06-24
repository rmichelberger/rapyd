//
//  WalletView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct WalletView: View {
    
//    @Binding private var profile: Profile
    
    @ObservedObject var viewModel: WalletViewModel
    @ObservedObject var transactionListViewModel: TransactionListViewModel
    @ObservedObject var checkoutViewModel: CheckoutViewModel

//    init(profile: Binding<Profile>) {
//        _profile = profile
//        viewModel = WalletViewModel(profile: profile.wrappedValue)
//        transactionListViewModel = TransactionListViewModel()
//        transactionListViewModel.load(walletId: profile.wrappedValue.id)

//    }
    
    //    @State private var balanceIndex = 0
    
    
    @ViewBuilder
    private var profileButton: some View {
        let profile = viewModel.profile
        NavigationLink(destination: LazyView(ProfileView())) {
            CircleTextView(text: profile.initiale, backgroundColor: Config.color(hash: profile.name.count))
                .foregroundColor(.white)
        }
        .isDetailLink(isIpad)
    }
    
    @ViewBuilder
    private func balanceView(width: CGFloat) -> some View {
        let profile = viewModel.profile
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.balances) { balance in
                    BalanceView(balance: balance, profile: profile).tag(balance.id)
                        .frame(width: width * 0.8)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var sendMoney: some View {
        NavigationLink(
            destination: LazyView(SendMoneyView(profile: viewModel.profile)),
            label: {
                VStack {
                    Image("send_money")
                        .resizable()
                        .scaledToFit()
                    Label("Send money", systemImage: "arrow.forward.circle")
                        .font(.title2)
                        .padding(.top, 8)
                }
                .padding()
                .foregroundColor(.white)
                
            })
            .isDetailLink(isIpad)
            .background(Color.purple.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private var requestMoney: some View {
        NavigationLink(
            destination: LazyView(RequestMoneyView(profile: viewModel.profile)),
            label: {
                VStack {
                    Image("request")
                        .resizable()
                        .scaledToFit()
                    Label("Request money", systemImage: "arrow.backward.circle")
                        .font(.title2)
                        .padding(.top, 8)
                }
                .padding()
                .foregroundColor(.white)
                
            })
            .isDetailLink(isIpad)
            .background(Color.pink.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private var transactionsView: some View {
        TransactionListRowView(viewModel: transactionListViewModel)
    }

    @ViewBuilder
    private var receiptsView: some View {
        ReceiptsWidgetView(viewModel: checkoutViewModel)
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                PaddedScrollView {
                    VStack(alignment :.leading) {
                        if viewModel.balances.isNotEmpty {
                            balanceView(width: geometry.size.width)
                        } else {
                            BalanceView(balance: Balance(id: "", currency: "", balance: 0, alias: ""), profile: viewModel.profile)
                                .frame(width: geometry.size.width * 0.8)
                                .padding(.horizontal)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                sendMoney
                                requestMoney
                            }
                            .padding()
                        }
                        .frame(maxHeight: 250)

                        transactionsView
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        receiptsView
                            .padding(.horizontal)
                            .padding(.bottom)

                    }
                }
                .onAppear {
                    print("onappear")
                    viewModel.loadBalances()
                    transactionListViewModel.load(walletId: viewModel.profile.id)
                }
                .navigationBarItems(leading: profileButton)
                .navigationTitle("Wallet")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        .onReceive(viewModel.$profile, perform: { profile in
//            print("onReceive", profile)
//            transactionListViewModel.load(walletId: profile.id)
//        })
    }
}


#if DEBUG
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView(viewModel: WalletViewModel(profile: .empty), transactionListViewModel: TransactionListViewModel(), checkoutViewModel: CheckoutViewModel())
            .preferredColorScheme(.dark)
    }
}
#endif
