//
//  ImageView.swift
//  rapyd
//
//  Created by Roland Michelberger on 08.06.21.
//

import SwiftUI
import Combine

struct ImageView<Content: View>: View  {
    
    @ObservedObject private var dataLoader: DataLoader
    @State var image: UIImage?
    
    private let placeholder: () -> Content
    @State private var cancellable: AnyCancellable?
    
    init(url: URL, @ViewBuilder placeholder: @escaping () -> Content) {
        dataLoader = DataLoader(url: url)
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                placeholder()
            }
        }
        .onAppear {
            cancellable?.cancel()
            cancellable = dataLoader.didLoad.sink { data in
                self.image = UIImage(data: data)
            }
            dataLoader.load()

        }
        .onDisappear {
            cancellable?.cancel()
        }

    }
}
