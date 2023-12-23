//
//  ContentView.swift
//  sparrowsprint9
//
//  Created by Artem Dragunov on 23.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State var dragOffset: CGSize = .zero
    @State var canvasCenter: CGPoint = .zero
    
    
    var body: some View {
        
        GeometryReader { proxy in
            
            Rectangle()
                .fill(.radialGradient(colors: [Color.yellow, Color.red],
                                      center: .center,
                                      startRadius: 60,
                                      endRadius: 120))
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
                    }  symbols: {
                        yellowBall().tag(1)
                        redBall(offset: dragOffset)
                            .tag(2)
                    }
                    
                } .gesture(DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation {
                            dragOffset = .zero
                        }
                    })
            
        }
    }
    
    func yellowBall() -> some View {
        Circle()
            .frame(width: 150, height: 150)
    }
    
    func redBall(offset: CGSize = .zero) -> some View {
        ZStack {
            Circle()
                .frame(width: 150, height: 150)
                .offset(offset)
        }
    }
    
    func cloudIcon() -> some View {
        
        Image(systemName: "cloud.sun.rain.fill")
            .font(.title)
            .foregroundColor(.white)
        
    }
}

extension CGSize {
    static func / (size: CGSize, divisor: Int) -> CGPoint {
        return CGPoint(x: size.width / CGFloat(divisor), y: size.height / CGFloat(divisor))
    }
}



#Preview {
    ContentView(dragOffset: CGSize.zero)
}
