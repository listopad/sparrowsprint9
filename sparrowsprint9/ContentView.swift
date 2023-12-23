//
//  ContentView.swift
//  SparrowSprint9
//
//  Created by Artem Dragunov on 23.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var dragOffset: CGSize = .zero
    @State private var canvasCenter: CGPoint = .zero
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(
                    RadialGradient(
                        gradient: .init(colors: [Color.yellow, Color.red]),
                        center: .center,
                        startRadius: 60,
                        endRadius: 120
                    )
                )
                .mask {
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.5))
                        context.addFilter(.blur(radius: 20))
                        
                        context.drawLayer { ctx in
                            for index in [1, 2] {
                                if let resolvedView = context.resolveSymbol(id: index) {
                                    ctx.draw(resolvedView, at: size / 2)
                                }
                            }
                        }
                    } symbols: {
                        ball().tag(1)
                        ball(offset: dragOffset).tag(2)
                    }
                }
                .overlay(
                    cloudIcon(offset: dragOffset)
                )
                .gesture(DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation {
                            dragOffset = .zero
                        }
                    }
                )
        }
    }
    
    func ball(offset: CGSize = .zero) -> some View {
        Circle()
            .frame(width: 150, height: 150)
            .offset(offset)
    }
    
    func cloudIcon(offset: CGSize = .zero) -> some View {
        Image(systemName: "cloud.sun.rain.fill")
            .font(.system(size: 60))
            .frame(width: 150, height: 150)
            .foregroundColor(.white)
            .offset(offset)
    }
}

extension CGSize {
    static func / (size: CGSize, divisor: Int) -> CGPoint {
        return CGPoint(x: size.width / CGFloat(divisor), y: size.height / CGFloat(divisor))
    }
}


#Preview {
    ContentView()
}
