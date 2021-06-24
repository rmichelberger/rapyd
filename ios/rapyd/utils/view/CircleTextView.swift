//
//  CircleTextView.swift
//  rapyd
//
//  Created by Roland Michelberger on 07.06.21.
//

import SwiftUI

struct CircleTextView: View {
    
    private let text: String
    private let font: Font
    private let padding: CGFloat
    private let backgroundColor: Color
    
    init(text: String, backgroundColor: Color = Color.secondary.opacity(0.3), font: Font = .headline, padding: CGFloat = 8) {
        self.text = text
        self.font = font
        self.padding = padding
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Text(text)
            .font(font)
            .padding(padding)
            .background(backgroundColor)
            .clipShape(Circle())
    }
}

#if DEBUG
struct CircleTextView_Previews: PreviewProvider {
    static var previews: some View {
        CircleTextView(text: "MM")
    }
}
#endif
