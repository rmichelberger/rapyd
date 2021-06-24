//
//  ActionView.swift
//  rapyd
//
//  Created by Roland Michelberger on 21.06.21.
//

import SwiftUI

struct ActionView: View {
    
    let actionType: ActionType
    
    @State private var index = 0
    
    var body: some View {
        VStack {
            PageView(selection: $index, indexDisplayMode: .always, indexBackgroundDisplayMode: .always) {
                ForEach(actionType.providers) { provider in
                    ActionProviderView(provider: provider)
                        .padding()
//                        .padding(.bottom, 70)
                }
            }
        }
        .navigationTitle(actionType.name)
    }
}

#if DEBUG
struct ActionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActionView(actionType: .insurance)
        }
    }
}
#endif
