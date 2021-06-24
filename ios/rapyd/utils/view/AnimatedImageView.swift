//
//  AnimatedImageView.swift
//  rapyd
//
//  Created by Roland Michelberger on 04.06.21.
//

import SwiftUI

struct AnimatedImageView: View {

    @State private var currentIndex = 0
    @State private var timer: Timer? = nil
    
    // there is a bug with "onDisappear"
    @State private var appear = 0

    private let imageNames: [String]

    init(imageNames: [String]) {
        if imageNames.isEmpty {
            self.imageNames = ["", ""]
        } else if imageNames.count == 1 {
            self.imageNames = [imageNames[0], imageNames[0]]
        } else {
            self.imageNames = imageNames
        }
    }
    
    @ViewBuilder
    private func imageView(name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
    }
        
    
    @ViewBuilder
    private var imagesView: some View {
        if currentIndex % 2 == 0 {
            imageView(name: imageNames[currentIndex % imageNames.count])
                .transition(.scale)
        } else {
            imageView(name: imageNames[(currentIndex) % imageNames.count])
                .transition(.scale)
        }
    }
    
    var body: some View {
        imagesView
            .onAppear {
                appear += 1
                if timer == nil {
                    timer = Timer.scheduledTimer(withTimeInterval: 2.4, repeats: true, block: { (timer) in
                        withAnimation(.spring(dampingFraction: 0.6)) {
                            currentIndex = (currentIndex + 1) % imageNames.count
                        }
//                        debugLog(currentIndex)
                    })
                }
            }
            .onDisappear {
                appear -= 1
                if appear < 1 {
                    timer?.invalidate()
                }
            }
    }
    
}

#if DEBUG
struct AnimatedImageView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedImageView(imageNames: [])
    }
}
#endif
