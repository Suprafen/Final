//
//  ContentView.swift
//  ChallenegeSeven
//
//  Created by Ivan Pryhara on 17/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var offset: CGSize = .zero
    @State private var imageName: String = "cloud.sun.rain.fill"
    
    private let data: [Int] = [0, 1]
    private let baseIndex: Int = 0
    private let dragableIndex: Int = 1
    
    private let startGradientRadius: Double = 50
    private let endGradientRadius: Double = 80
    private let circleRadius: Double = 80
    
    var body: some View {
        ZStack {
            Color.purple.opacity(0.5).ignoresSafeArea()
            Rectangle()
                .fill(
                    RadialGradient(
                        gradient: .init(colors: [Color.yellow, Color.red]),
                        center: .center,
                        startRadius: startGradientRadius,
                        endRadius: endGradientRadius
                    ))
                .mask {
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.3, color: .yellow))
                        context.addFilter(.blur(radius: 25))
                        context.drawLayer { drawContext in
                            for index in data {
                                if let view = drawContext.resolveSymbol(id: index) {
                                    drawContext.draw(view, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                }
                            }
                        }
                    } symbols: {
                        Circle()
                            .frame(width: circleRadius)
                            .tag(baseIndex)
                        Circle()
                            .frame(width: circleRadius)
                            .offset(offset)
                            .tag(dragableIndex)
                    }
                }
                .overlay(
                    Image(systemName: imageName)
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .offset(offset)
                )
                .gesture(
                    DragGesture()
                        .onChanged {
                            offset = $0.translation
                            imageName = "swift"
                        }
                        .onEnded { _ in
                            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
                                offset = .zero
                            } completion: {
                                imageName = "cloud.sun.rain.fill"
                            }
                        }
                )
        }
    }
}

#Preview {
    ContentView()
}
