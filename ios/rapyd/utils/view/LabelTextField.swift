//
//  LabelTextField.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//


import SwiftUI

struct LabelTextField: View {
    
    let label: String
    let placeholder: String
    @Binding var text: String
    let keyboardtype: UIKeyboardType
    @State var hasFocus: Binding<Bool>? = nil

    init(label: String, placeholder: String = "", text: Binding<String>, keyboardtype: UIKeyboardType = .default) {
        self.label = label
        self.placeholder = placeholder
        _text = text
        self.keyboardtype = keyboardtype
    }
    
    @State private var isVisible = false
    
    private func set(visible: Bool) {
        if self.isVisible != visible {
            withAnimation { self.isVisible.toggle() }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                if isVisible {
                    Text(label).labelStyle()
                        .transition(.scale)
                        .padding(.bottom, 1)
                }
                TextField(placeholder, text: Binding<String>(get: {
                    text
                }, set: {
                    text = $0
                    set(visible: text.isNotEmpty)
                })) { (editingChanged) in
                    hasFocus?.wrappedValue = editingChanged
                }
                .keyboardType(keyboardtype)
            }.onAppear {
                set(visible: text.isNotEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.secondary.opacity(0.2))
    }
}

#if DEBUG
struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextField(label: "label", placeholder: "placeholder", text: .constant("text"))
    }
}
#endif
