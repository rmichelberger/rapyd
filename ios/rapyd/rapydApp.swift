//
//  rapydApp.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

@main
struct rapydApp: App {
    
//        @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject private var viewModel = RegistrationViewModel()
    private let walletViewModel = WalletViewModel(profile: .empty)
    private let transactionListViewModel = TransactionListViewModel()
    private let paymentViewModel = PaymentViewModel()
    private let checkoutViewModel = CheckoutViewModel()

    @ObservedObject var urlHandler = URLHandler.shared
    
    @State private var isLocked = true
    
    private var isPresented: Bool {
        viewModel.isRegistrationViewShown || isLocked ||
            urlHandler.checkoutIds.isNotEmpty ||
            urlHandler.sendMoneyIds.isNotEmpty ||
            urlHandler.requestMoneyIds.isNotEmpty
    }
    
    var body: some Scene {
        WindowGroup {
            WalletView(viewModel: walletViewModel, transactionListViewModel: transactionListViewModel, checkoutViewModel: checkoutViewModel)
                .onReceive(viewModel.$profile, perform: { profile in
                    walletViewModel.profile = profile
                })
                .fullScreenCover(isPresented: Binding<Bool>(get: { isPresented }, set: { (shown) in
                    viewModel.isRegistrationViewShown = shown
                    isLocked = shown
                }), content: {
                    if viewModel.isRegistrationViewShown {
                        RegistrationView(viewModel: viewModel)
                    } else if isLocked {
                        PinView {
                            isLocked = false
                        }
                    } else if let checkoutId = urlHandler.checkoutIds.first {
                        CheckoutView(checkoutId: checkoutId, profile: viewModel.profile, viewModel: checkoutViewModel, paymentViewModel: paymentViewModel)
                            .onDisappear {
                                walletViewModel.loadBalances()
                                transactionListViewModel.load(walletId: viewModel.profile.id)
                            }
                    } else if let requestMoneyId = urlHandler.requestMoneyIds.first {
                        HandleRequestPaymentView(id: requestMoneyId, myWalletId: viewModel.profile.id, viewModel: paymentViewModel)
                            .onDisappear {
                                walletViewModel.loadBalances()
                                transactionListViewModel.load(walletId: viewModel.profile.id)
                            }
                    } else if let sendMoneyId = urlHandler.sendMoneyIds.first {
                        HandleSendMoneyView(id: sendMoneyId, myWalletId: viewModel.profile.id, viewModel: paymentViewModel)
                            .onDisappear {
                                walletViewModel.loadBalances()
                                transactionListViewModel.load(walletId: viewModel.profile.id)
                            }
                    }
                })
                .onOpenURL { (url) in
                    urlHandler.handle(url: url)
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    guard let url = userActivity.webpageURL else {
                        return
                    }
                    urlHandler.handle(url: url)
                }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                debugLog("App is active")
            case .inactive:
                debugLog("App is inactive")
            case .background:
                debugLog("App is in background")
                
                Main {
                    isLocked = true
                }
                
            @unknown default:
                debugLog("Oh - interesting: I received an unexpected new value.")
            }
        }
    }
    
}


/*
 class AppDelegate: NSObject, UIApplicationDelegate {
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
 
 // if push notification enabled
 //        RemotePushNotification.updateToken()
 
//         URLHandler.shared.handle(url: URL(string: "https://rapyd-pay.web.app/checkout/checkout.html?id=checkout_d63e006f0fcb8f3eef9b2e244bf695e4")!)
 
 //        URLHandler.shared.handle(url: URL(string: "https://rapyd-pay.web.app/request/?id=payment_5bffaad78e0b6a518829f08719d744e7")!)
 
 
//         URLHandler.shared.handle(url: URL(string: "https://rapyd-pay.web.app/checkout/checkout.html?id=checkout_558bf02e31cc1d4873da98d651532e62")!)
 
 return true
 }}
 
 
 
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 
 // send token to server
 //        RemotePushNotification.sendDeviceTokeToServer(deviceToken: deviceToken)
 }
 
 func application(_ application: UIApplication,
 didReceiveRemoteNotification notification: [AnyHashable : Any],
 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
 }
 
 func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
 return URLHandler.shared.handle(url: url)
 }
 
 func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
 guard let url = userActivity.webpageURL else { return false }
 
 return URLHandler.shared.handle(url: url)
 }
 }
 
 */
