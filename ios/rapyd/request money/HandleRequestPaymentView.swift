//
//  HandleRequestPaymentView.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import SwiftUI

struct HandleRequestPaymentView: View {
    
    let id: String
    let myWalletId: String
    
    @ObservedObject var viewModel: PaymentViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var message = ""
    @State private var errorMessage = ""
    
    @ViewBuilder
    private func label(label: String, text: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
            Text(text)
                .font(.title2)
        }
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                HStack {
                    Text("Requested money")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(.vertical)
                Spacer()
                ProgressView()
                Spacer()
            } else {
                HStack {
                    Text("Requested money")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(.vertical)
                if let payment = viewModel.payment {
                    Text(payment.money.fomattedString)
                        .moneyLabelStyle()
                        .padding()
                }
                if let profile = viewModel.profile {
                    Text("By")
                        .font(.title)
                    label(label: "Name", text: profile.name)
                    label(label: "Email", text: profile.email)
                    let profileViewModel = ProfileViewModel(profile: profile)
                    label(label: "Address", text: profileViewModel.formattedAddress)
                }
                Spacer()
                
                Image("send_money")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Spacer()
                HStack {
                    Button("Reject") {
                        URLHandler.shared.requestMoneyFinished(id: id)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                    Spacer()
                    PrimaryButton("Send money") {
                        message = ""
                        errorMessage = ""
                        guard let payment = viewModel.payment, let profile = viewModel.profile else { return }
                        viewModel.move(money: payment.money, from: myWalletId, to: payment.ewallet_id) { error in
                            if let _ = error {
                                errorMessage = "An error occured, please try again"
                            } else {
                                message = "\(payment.money.fomattedString) was sent to \(profile.name)"
                            }
                        }
                    }
                }
                .padding(30)
            }
        }
        .padding(.horizontal)
        .onAppear {
            viewModel.getPayment(id: id)
        }
        .alert(isPresented: Binding<Bool>(get: { message.isNotEmpty || errorMessage.isNotEmpty }, set: { show in
            message = ""
            errorMessage = ""
        })) {
            if errorMessage.isNotEmpty {
                return Alert(title: Text("Ooops"), message: Text(errorMessage), dismissButton: nil)
            } else if message.isNotEmpty {
                
                return Alert(title: Text("Congratulation 🎉"), message: Text(message), dismissButton: .default(Text("OK"), action: {
                    URLHandler.shared.requestMoneyFinished(id: id)
                    presentationMode.wrappedValue.dismiss()
                }))
            }
            return Alert(title: Text("Looks like there was a glitch in the matrix.."))
        }
    }
}

#if DEBUG
struct HandleRequestPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        HandleRequestPaymentView(id: "", myWalletId: "", viewModel: PaymentViewModel())
    }
}
#endif
