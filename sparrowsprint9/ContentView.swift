//
//  ContentView.swift
//  sparrowsprint9
//
//  Created by Artem Dragunov on 23.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State var dragOffset: CGSize
    
    var body: some View {
        
        Rectangle()
            .fill(.linearGradient(colors: [Color.red, Color.yellow], startPoint: .top, endPoint: .bottom))
        
            .mask {
                
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .red))
                    context.addFilter(.blur(radius: 30))
                    
                    context.drawLayer { ctx in
                        for index in [1, 2] {
                            
                            if let resolvedView = context.resolveSymbol(id: index) {
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                            }
                            
                        }
                    }
                }  symbols: {
                    yellowBall().tag(1)
                    redBall(offset: dragOffset).tag(2)
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
    
    func yellowBall() -> some View {
        Circle()
            .fill(.yellow)
            .frame(width: 150, height: 150)
    }
    
    func redBall(offset: CGSize = .zero) -> some View {
        Circle()
            .fill(.red)
            .frame(width: 150, height: 150)
            .offset(offset)
    }
}



#Preview {
    ContentView(dragOffset: CGSize.zero)
}
