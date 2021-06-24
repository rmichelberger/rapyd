//
//  ActionProviderView.swift
//  rapyd
//
//  Created by Roland Michelberger on 22.06.21.
//

import SwiftUI

struct ActionProviderView: View {
    
    let provider: ActionProvider
    
    private let colors = [Color.pink, Color.blue, Color.yellow, Color.orange, Color.purple]
    
    var body: some View {
        VStack {
            Text(provider.company)
                .padding(.bottom)
            ImageView(url: provider.imageURL) {
                ProgressView()
            }
            .frame(width: 240, alignment: .center)
            .padding(.bottom, 40)
            Text(provider.name)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Text(provider.price.fomattedString)
                .moneyLabelStyle()
                .padding(.vertical, 30)
        }
        .foregroundColor(.white)
        .padding()
        .background(colors[provider.id % colors.count])
        .clipShape(RoundedRectangle(cornerRadius: 24))
        
    }
}

struct ActionProviderView_Previews: PreviewProvider {
    static var previews: some View {
        ActionProviderView(provider: ActionProvider(id: 1, company: "FWD", imageURL: URL(string: "https://fdwinsurance.com/wp-content/uploads/2021/04/2018_10_24_56955_1540345959._large.jpg")!, name: "FWD First", price: Money(amount: 18.75, currency: "SGD")))
    }
}
