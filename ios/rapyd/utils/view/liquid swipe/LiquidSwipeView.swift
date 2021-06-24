//
//  ContentView.swift
//  LiquidSwipeSwiftUI
//
//  Created by Mark Goldin on 08/08/2019.
//  Copyright © 2019 Exyte. All rights reserved.
//

import SwiftUI

struct LiquidSwipeView: View {
    
    private let contents: [AnyView]
    
    init(contents: [AnyView], pageIndex: Binding<Int>) {
        self.contents = contents
        _pageIndex = pageIndex
    }
    
    @State private var leftData = SliderData(side: .left)
    @State private var rightData = SliderData(side: .right)
    
    @Binding var pageIndex: Int {
        didSet {
            let index = pageIndex % contents.count
            if index == contents.count - 1 {
                Config.shuffleColors()
            }
        }
    }
    @State private var topSlider = SliderSide.right
    @State private var sliderOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            let index = pageIndex % contents.count
            let notFirst = index != 0
            let notLast = index < contents.count - 1
            //            let leadingPadding: CGFloat = notFirst ? 15 : 0
            let trailingPadding: CGFloat = notLast ? 15 : 0
            
            //            if notLast {
            Rectangle().foregroundColor(Config.colors[pageIndex])
            //            }
            
            contents[index]
                //                .padding(.horizontal, 15)
                .padding(.leading, 15)
                //                .padding(.leading, leadingPadding)
                .padding(.trailing, trailingPadding)
            
            if notFirst {
                slider(data: $leftData)
            }
            
            if notLast {
                slider(data: $rightData)
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .onAppear {
            initialAnimation()
        }
    }
    
    @ViewBuilder
    private func slider(data: Binding<SliderData>) -> some View {
        let value = data.wrappedValue
        ZStack {
            wave(data: data)
            button(data: value)
        }
        .zIndex(topSlider == value.side ? 1 : 0)
        .offset(x: value.side == .left ? -sliderOffset : sliderOffset)
    }
    
    //    func content() -> some View {
    //        return Rectangle().foregroundColor(Config.colors[pageIndex])
    //    }
    
    @ViewBuilder
    private func button(data: SliderData) -> some View {
        let aw = (data.side == .left ? 1 : -1) * Config.arrowWidth / 2
        let ah = Config.arrowHeight / 2
        ZStack {
            circle(radius: Config.buttonRadius).stroke().opacity(0.2)
            polyline(-aw, -ah, aw, 0, -aw, ah).stroke(Color.white, lineWidth: 2)
        }
        .offset(data.buttonOffset)
        .opacity(data.buttonOpacity)
    }
    
    @ViewBuilder
    private func wave(data: Binding<SliderData>) -> some View {
        let gesture = DragGesture().onChanged {
            self.topSlider = data.wrappedValue.side
            data.wrappedValue = data.wrappedValue.drag(value: $0)
        }
        .onEnded {
            if data.wrappedValue.isCancelled(value: $0) {
                withAnimation(.spring(dampingFraction: 0.5)) {
                    data.wrappedValue = data.wrappedValue.initial()
                }
            } else {
                self.swipe(data: data)
            }
        }
        .simultaneously(with: TapGesture().onEnded {
            self.topSlider = data.wrappedValue.side
            self.swipe(data: data)
        })
        WaveView(data: data.wrappedValue).gesture(gesture)
            .foregroundColor(Config.colors[index(of: data.wrappedValue)])
    }
    
    private func swipe(data: Binding<SliderData>) {
        withAnimation() {
            data.wrappedValue = data.wrappedValue.final()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.pageIndex = self.index(of: data.wrappedValue)
            self.leftData = self.leftData.initial()
            self.rightData = self.rightData.initial()
            
            self.sliderOffset = 100
            withAnimation(.spring(dampingFraction: 0.5)) {
                self.sliderOffset = 0
            }
        }
    }
    
    private func initialAnimation() {
        let data = $rightData
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation() {
                //                withAnimation(.spring(dampingFraction: 0.5)) {
                data.wrappedValue = data.wrappedValue.initialAnimation()
            }
        }
        //            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation() {
                data.wrappedValue = data.wrappedValue.initial()
            }
        }
        
    }
    
    private func index(of data: SliderData) -> Int {
        let last = Config.colors.count - 1
        if data.side == .left {
            return pageIndex == 0 ? last : pageIndex - 1
        } else {
            return pageIndex == last ? 0 : pageIndex + 1
        }
    }
    
    private func circle(radius: Double) -> Path {
        return Path { path in
            path.addEllipse(in: CGRect(x: -radius, y: -radius, width: radius * 2, height: radius * 2))
        }
    }
    
    private func polyline(_ values: Double...) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: values[0], y: values[1]))
            for i in stride(from: 2, to: values.count, by: 2) {
                path.addLine(to: CGPoint(x: values[i], y: values[i + 1]))
            }
        }
    }
    
}
