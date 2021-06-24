//
//  CurrencyPickerView.swift
//  rapyd
//
//  Created by Roland Michelberger on 10.06.21.
//

import SwiftUI

struct CurrencyPickerView: View {
    
    @Binding var currency: String
        
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var search = ""

    private var currencies: [String] {
        
        Locale.isoCurrencyCodes.filter({ search.isEmpty ? true : $0.localizedCaseInsensitiveContains(search) })
    }
    
    var body: some View {
        VStack {
            
            SearchBarView(placeHolder: "Search", text: $search)
                .padding(.horizontal)
            
            List(currencies, id: \.self) { currency in
                Button(currency) {
                    self.currency = currency
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Choose currency")
    }
}

struct CurrencyPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyPickerView(currency: .constant(""))
    }
}
