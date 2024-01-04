//
//  File.swift
//  
//
//  Created by Brian Masse on 1/1/24.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
#Preview {
    LargeTextButton("hel lo",
                    at: 45,
                    aspectRatio: 1.5,
                    verticalTextAlignment: .bottom,
                    arrowDirection: .up,
                    style: .green) {
        print("hi!")
    }
}

@available(iOS 16.0, *)
public struct LargeTextButton<T: ShapeStyle>: View {
    
    public enum ArrowDirection: Int {
        case up = 1
        case down = -1
        
        func translateToAlignment() -> Alignment {
            switch self {
            case .up: return .top
            case .down: return .bottom
            }
        }
    }
    
    let text: String
    let angle: Double

    let aspectRatio: Double
    let verticalTextAlignment: Alignment
    
    let arrowDirection: ArrowDirection
    let arrowWidth: CGFloat
    let arrow: Bool
    
    let style: T
    let width: CGFloat
    
    let action: () -> Void
    
    public init( _ text: String,
          at angle: Double,
          aspectRatio: Double = 2,
          verticalTextAlignment: Alignment = .bottom,
          arrow: Bool = true,
          arrowDirection: ArrowDirection = .down,
          arrowWidth: CGFloat = 4,
          style: T = Color.red,
          width: CGFloat = 100,
          action: @escaping () -> Void
    ) {
        
        self.text = text
        self.angle = angle
        self.aspectRatio = aspectRatio
        self.verticalTextAlignment = verticalTextAlignment
        
        self.arrow = verticalTextAlignment == .center ? false : arrow
        self.arrowWidth = arrowWidth
        self.arrowDirection = arrowDirection
        
        self.style = style
        self.width = width
        
        self.action = action
    
    }
    
    @ViewBuilder
    private func makeShape(_ contentMode: ContentMode) -> some View {
        
        Rectangle()
            .aspectRatio(1 / aspectRatio, contentMode: contentMode)
            .frame(width: width)
            .cornerRadius(Constants.UIDefaultCornerRadius)
            .foregroundStyle( self.style )
    }
    
    @ViewBuilder
    private func makeArrow() -> some View {

        let halfArrowWidth = arrowWidth / 2
        
        GeometryReader { geo in
            
            ZStack(alignment: arrowDirection.translateToAlignment() ) {
                Rectangle()
                    .foregroundStyle(.clear)
                
                Rectangle()
                    .frame(width: arrowWidth)
                
                let arrowHeadWidth = geo.size.width / 2.5
                
                Group {
                    Rectangle()
                        .offset(x: -arrowHeadWidth / 2 + halfArrowWidth)
                        .frame(width: arrowHeadWidth, height: arrowWidth)
                        .rotationEffect(.degrees( Double(arrowDirection.rawValue) * -45))
                    
                    Rectangle()
                        .offset(x: arrowHeadWidth / 2 - halfArrowWidth)
                        .frame(width: arrowHeadWidth, height: arrowWidth)
                        .rotationEffect(.degrees( Double(arrowDirection.rawValue) * 45))
                }
                .offset(y: CGFloat(arrowDirection.rawValue) * -arrowWidth)
            }
        }
    }
    
    private func transformText() -> String {
        var text = text.components(separatedBy: .whitespaces).reduce("") { partialResult, str in
            partialResult + "\n" + str
        }
        text.removeFirst()
        return text
    }
    
    private func degreeToRad() -> Double { angle * ( Double.pi / 180 ) }
    
    private func invertVerticalTextAlignment() -> Alignment {
        switch verticalTextAlignment {
        case .top: return .bottom
        case .bottom: return .top
        default: return verticalTextAlignment
        }
    }
    
    public var body: some View {
        
        let transformedText = transformText()
        
        RotatedLayout(at: degreeToRad(), scale: 0.9) {
            ZStack(alignment: verticalTextAlignment) {
                
                makeShape(.fit)
                    .overlay() { if arrow {
                        GeometryReader { geo in
                            ZStack(alignment: invertVerticalTextAlignment() ) {
                                Rectangle()
                                    .foregroundStyle(.clear)
//
                                makeArrow()
                                    .if(verticalTextAlignment == .top) { view in view.padding(.bottom, 20 ) }
                                    .if(verticalTextAlignment != .top) { view in view.padding(.vertical, 20 ) }
                                    .frame(height: !text.isEmpty ? geo.size.height / 2 : geo.size.height - 20)
                            }
                        }
                    }}
                if !text.isEmpty {
                    RotatedLayout(at: 0, scale: 0.7) {
                        UniversalText(transformedText,
                                      size: Constants.UIHeaderTextSize + 10,
                                      font: Constants.mainFont,
                                      case: .uppercase,
                                      scale: true,
                                      textAlignment: .center,
                                      lineSpacing: -25)
                        .scaleEffect(CGSize(width: 0.7, height: 0.7))
                        .rotationEffect(.degrees(-angle))
                        .allowsHitTesting(false)
                    }
                    .padding(.vertical)
                    .mask(alignment: verticalTextAlignment ) { makeShape(.fill) }
                }
            }
            .frame(width: width, height: width * aspectRatio)
            .onTapGesture { withAnimation { action() } }
            .rotationEffect(.degrees(angle))
        }
    }
}
