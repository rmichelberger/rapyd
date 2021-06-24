//
//  HandleSendMoneyView.swift
//  rapyd
//
//  Created by Roland Michelberger on 11.06.21.
//

import SwiftUI

struct HandleSendMoneyView: View {
    
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
                    Text("You've received money")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(.vertical)
                Spacer()
                ProgressView()
                Spacer()
            } else {
                HStack {
                    Text("You've received money")
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
                    Text("From")
                        .font(.title)
                    label(label: "Name", text: profile.name)
                    label(label: "Email", text: profile.email)
                    let profileViewModel = ProfileViewModel(profile: profile)
                    label(label: "Address", text: profileViewModel.formattedAddress)
                }
                Spacer()

                Image("request")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Spacer()
                
                HStack {
                    Button("Reject") {
                        URLHandler.shared.sendMoneyFinished(id: id)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                    Spacer()
                    PrimaryButton("Collect money") {
                        message = ""
                        errorMessage = ""
                        guard let payment = viewModel.payment, let profile = viewModel.profile else { return }
                        viewModel.move(money: payment.money, from: payment.ewallet_id, to: myWalletId) { error in
                            if let _ = error {
                                errorMessage = "An error occured, please try again"
                            } else {
                                message = "\(payment.money.fomattedString) was received from \(profile.name)"
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
                    URLHandler.shared.sendMoneyFinished(id: id)
                    presentationMode.wrappedValue.dismiss()
                }))
            }
            return Alert(title: Text("Looks like there was a glitch in the matrix.."))
        }
    }}

struct HandleSendMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        HandleSendMoneyView(id: "", myWalletId: "", viewModel: PaymentViewModel())        
    }
}
