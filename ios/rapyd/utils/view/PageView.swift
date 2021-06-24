//
//  PageView.swift
//  rapyd
//
//  Created by Roland Michelberger on 01.06.21.
//

import SwiftUI

struct PageView<Content: View>: View {
    
    @Binding  var selection: Int
    
    private let indexDisplayMode: PageTabViewStyle.IndexDisplayMode
    private let indexBackgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode
    private let content: () -> Content
    
    @State private var animation: Animation? = nil

    init(
        selection: Binding<Int>,
        indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic,
        indexBackgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode = .automatic,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _selection = selection
        self.indexDisplayMode = indexDisplayMode
        self.indexBackgroundDisplayMode = indexBackgroundDisplayMode
        self.content = content
    }

    var body: some View {
        TabView(selection: $selection) {
            content()
        }
        .animation(animation)
        .onAppear {
            DispatchQueue.main.async {
                animation = .easeInOut
            }
        }
        .transition(.slide)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: indexDisplayMode))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: indexBackgroundDisplayMode))
    }
}

#if DEBUG
struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(selection: .constant(0), indexDisplayMode: .always, indexBackgroundDisplayMode: .always) {
            Text("1")
            Text("2")
        }
    }
}
#endif
