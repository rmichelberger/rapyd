//
//  SearchBarView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//


import SwiftUI

struct SearchBarView: View {
    
    let placeHolder: String
    @Binding var text: String
    
    @State private var isEditing = false
    
    private func set(editing: Bool) {
        withAnimation { isEditing = editing }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(placeHolder, text: $text) { (edit) in
                set(editing: edit)
            } onCommit: {
                set(editing: false)
            }
            
            if isEditing {
                Button(action: {
                    isEditing = false
                    text = ""
                    hideKeyboard()
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.scale)
                .animation(.default)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.3)))
    }
}

#if DEBUG
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(placeHolder: "", text: .constant(""))
    }
}
#endif
