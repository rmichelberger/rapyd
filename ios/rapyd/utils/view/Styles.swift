//
//  Styles.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

extension View {

    @ViewBuilder
    func labelStyle() -> some View {
        self.modifier(LabelModifier())
    }
    
    @ViewBuilder
    func moneyLabelStyle() -> some View {
        self.modifier(MoneyLabelModifier())
    }

}

struct LabelModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct MoneyLabelModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.system(size: 42, weight: .thin, design: .monospaced))
    }
}
