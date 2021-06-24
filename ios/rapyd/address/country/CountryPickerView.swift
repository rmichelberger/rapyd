//
//  CountryPickerView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct CountryPickerView: View {
    
    @Binding var country: Country
    
    @ObservedObject private var viewModel = CountryViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        PaddedScrollView {
            SearchBarView(placeHolder: "Search", text: $viewModel.searchText)
                .padding(.horizontal)
            ForEach(viewModel.countries) { country in
                Button(action: {
                    self.country = country
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Text(country.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                })
            }
        }
        .navigationTitle("Select country")
    }
}

#if DEBUG
struct CountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerView(country: .constant(.empty))
    }
}
#endif
