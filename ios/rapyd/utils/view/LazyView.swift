//
//  LazyView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let content: () -> Content
    
    init(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }
    
    var body: Content {
        content()
    }
}

#if DEBUG
struct LazyView_Previews: PreviewProvider {
    static var previews: some View {
        LazyView(Text("Text"))
    }
}
#endif
