//
//  AddressView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct AddressView: View {
    
    @Binding private var address: Address?
    @ObservedObject private var viewModel: AddressViewModel
    
//    @State private var isAlertShowing = false
//    @Environment(\.presentationMode) private var presentationMode
    
    init(address: Binding<Address?>) {
        _address = address
        viewModel = AddressViewModel(address: address.wrappedValue ?? .empty )
    }
    
    var body: some View {
        PaddedScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Country")
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 1)
                    .labelStyle()
                
                NavigationLink(destination: CountryPickerView(country: $viewModel.country)) {
                    if viewModel.country.name.isEmpty {
                        Text("Select country")
                    } else {
                        Text(viewModel.country.name)
                    }
                }.isDetailLink(isIpad)
                .padding(.horizontal)
                
                LabelTextField(label: "State", placeholder: "Add a state", text: $viewModel.state)
                    .padding(.top)
                
                LabelTextField(label: "City", placeholder: "Add a city", text: $viewModel.city)
                    .padding(.top)
                
                LabelTextField(label: "Postal code", placeholder: "Add a postal code", text: $viewModel.zip)
                    .padding(.top)
                
                LabelTextField(label: "Street, Nr.", placeholder: "Add a street and Nr.", text: $viewModel.street)
                    .padding(.top)
                
                Text("Postal address")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 4)
                Text(viewModel.formattedAddress)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .navigationTitle("Set address")
//        .navigationBarItems(trailing: Button(action: {
//            isAlertShowing.toggle()
//        }) {
//            Image(systemName: "trash")
//                .foregroundColor(.red)
//        })
        .onReceive(viewModel.addressPublisher) { address in
            self.address = address
        }
//        .alert(isPresented: $isAlertShowing) { () -> Alert in
//            Alert(title: Text("Do you really want to delete it?"), message: Text("It can't be undone"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
//                address = nil
//                presentationMode.wrappedValue.dismiss()
//            }))
//        }
    }
}

#if DEBUG
struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(address: .constant(Address(countryCode: "", state: "", city: "", zip: "", street: "")))
    }
}
#endif
