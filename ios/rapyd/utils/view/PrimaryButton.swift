//
//  PrimaryButton.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct PrimaryButton<Content: View>: View {
    
    let action: () -> Void
    
    private let content: () -> Content
    
    init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
        
    var body: some View {
        Button(action: action) {
            content()
        }.buttonStyle(PrimaryButtonStyle())
    }
}

extension PrimaryButton where Content == Text {
    
    
    init(_ title: String, action: @escaping () -> Void) {
        self.content = { Text(title) }
        self.action = action
    }

}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        PrimaryButtonStyleView(configuration: configuration)
    }
}

private extension PrimaryButtonStyle {
    
    struct PrimaryButtonStyleView: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: PrimaryButtonStyle.Configuration
        
        var body: some View {
            return configuration.label
                .padding(.horizontal)
                .padding(.vertical, 6)
                .foregroundColor(isEnabled ? .white : .secondary)
                .background(RoundedRectangle(cornerRadius: 8)
                                .fill(isEnabled ? Color.blue : Color.gray)
                )
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
//                .animation(.spring())
        }
    }
}

#if DEBUG
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton("Primary Button") {}
    }
}
#endif
