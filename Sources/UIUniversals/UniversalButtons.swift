//
//  File.swift
//  
//
//  Created by Brian Masse on 1/1/24.
//

import Foundation
import SwiftUI

//MARK: UniversalButton
@available(iOS 16.0, *)
public struct UniversalButton<C: View>: View {
    
    let label: C
    let action: () -> Void
    let animate: Bool
    
    private struct OpacityButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .opacity( configuration.isPressed ? 0.6 : 1 )
            
        }
    }
    
    private struct NoTapAnimationStyle: PrimitiveButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .contentShape(Rectangle())
                .onTapGesture(perform: configuration.trigger)
        }
    }
    
    public init( shouldAnimate: Bool = true, labelBuilder: () -> C, action: @escaping () -> Void) {
        self.label = labelBuilder()
        self.action = action
        self.animate = shouldAnimate
    }
    
    public var body: some View {
        Button { withAnimation {
            action()
        } } label: { label }
            .if( animate ) { view in view.buttonStyle( OpacityButtonStyle() ) }
            .if( !animate ) { view in view.buttonStyle( NoTapAnimationStyle() ) }
    }
}


//MARK: LargeTextButton
///The LargeTextButton is a pill shaped button that contains a brief amount of text and an arrow pointing along the direction of the button. It can be rotated 360 degrees, and stretched to fit the text. For the best effect it is recommended that the text be separated into multiple, short lines. ie. 'hello \nworld!' To see examples check out [this repo](https://github.com/Brian-Masse/UIUniversalsExample)
@available(iOS 16.0, *)
public struct LargeTextButton: View {
    
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
    
    let style: UniversalStyle
    let color: Color?
    let width: CGFloat
    
    let action: () -> Void
    
    public init( _ text: String,
                 at angle: Double,
                 aspectRatio: Double = 2,
                 verticalTextAlignment: Alignment = .bottom,
                 arrow: Bool = true,
                 arrowDirection: ArrowDirection = .down,
                 arrowWidth: CGFloat = 4,
                 style: UniversalStyle = .accent,
                 color: Color? = nil,
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
        self.color = color
        self.width = width
        
        self.action = action
    
    }
    
    @ViewBuilder
    private func makeShape(_ contentMode: ContentMode) -> some View {
        
        Rectangle()
            .aspectRatio(1 / aspectRatio, contentMode: contentMode)
            .frame(width: width)
            .cornerRadius(Constants.UIDefaultCornerRadius)
            .universalStyledBackgrond(style, color: color, onForeground: true)
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
        
        UniversalButton {
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
                .foregroundStyle(.black)
                .frame(width: width, height: width * aspectRatio)
            }
        } action: { action() }
            .rotationEffect(.degrees(angle))
    }
}

//MARK: LargeRoundedButton
///The LargeRoundedButton is a simple, pill shaped button that contains text and an SFSymbol icon. It also supports two states, a toggle on and a toggle off, which can display different labels / icons. To see examples check out [this repo](https://github.com/Brian-Masse/UIUniversalsExample)
@available(iOS 16.0, *)
public struct LargeRoundedButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let label: String
    let completedLabel: String
    let icon: String
    let completedIcon: String
    
    let completed: () -> Bool
    let action: () -> Void
    
    let small: Bool
    let wide: Bool
    
    let color: Color?
    let style: UniversalStyle
    
    @State var tempCompletion: Bool = false
//    
//    @ViewBuilder var contentLabel: (String) -> Content
//    
//    @ViewBuilder
//    public static func defaultContentLabel( _ label: String ) -> Content {
//        UniversalText(label, size: Constants.UISubHeaderTextSize, font: FontProvider[.syneHeavy]) as! Content
//    }
    
    public init( _ label: String, to completedLabel: String = "",
                 icon: String, to completedIcon: String = "",
                 wide: Bool = false,
                 small: Bool = false,
                 color: Color? = nil,
                 style: UniversalStyle = .accent,
//                 @ViewBuilder labelBuilder: @escaping (String) -> Content = LargeRoundedButton.defaultContentLabel,
                 completed: @escaping () -> Bool = {false},
                 action: @escaping () -> Void ) {
        
        self.label = label
        self.completedLabel = completedLabel
        self.icon = icon
        self.completedIcon = completedIcon
        
        self.completed = completed
        self.action = action
        
        self.wide = wide
        self.small = small
        
        self.color = color
        self.style = style
        
//        self.contentLabel = labelBuilder
    }
    
    public var body: some View {
        let label: String = (self.completed() || tempCompletion ) ? completedLabel : label
        let completedIcon: String = (self.completed() || tempCompletion ) ? completedIcon : icon
        
        UniversalButton(shouldAnimate: self.completedLabel.isEmpty && self.completedIcon.isEmpty) {
            HStack {
                if wide { Spacer() }
                if label != "" {
                    UniversalText(label, size: Constants.UISubHeaderTextSize, font: FontProvider[.syneHeavy])
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                }
                
                if completedIcon != "" {
                    Image(systemName: completedIcon)
                }
                if wide { Spacer() }
            }
            .padding(.vertical, small ? 7: 25 )
            .padding(.horizontal, small ? 25 : 25)
            .universalStyledBackgrond(style, color: color)
            .cornerRadius(Constants.UIDefaultCornerRadius)
            .animation(.default, value: completed() )
            
        } action: { withAnimation { action() } }
    }
}

//MARK: UnderlinedButton
///The UnderlinedButton is a simple underlined label containing text and an SF icon. The button supports two states, a toggle on and a toggle off, which will either highlight the button in the app's accent color if on, or fade it into the background when it is toggled off. To see examples check out [this repo](https://github.com/Brian-Masse/UIUniversalsExample)
@available(iOS 16.0, *)
public struct UnderlinedButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    let icon: String

    let scale: Bool
    
    let condition: () -> Bool
    let action: () -> Void
    
    public init( _ title: String,
                 icon: String = "",
                 scale: Bool = false,
                 condition: @escaping () -> Bool = { false },
                 action: @escaping () -> Void ) {
        self.title = title
        self.icon = icon
        self.scale = scale
        self.condition = condition
        self.action = action
        
    }
    
    public var body: some View {
        
        UniversalButton(shouldAnimate: false) {
            VStack(spacing: 0) {
                ZStack {
                    UniversalText( "H",
                                   size: Constants.UISubHeaderTextSize,
                                   font: Constants.mainFont,
                                   case: .uppercase)
                    .foregroundStyle(.clear)
                        
                    HStack {
                        UniversalText( title,
                                       size: Constants.UISubHeaderTextSize,
                                       font: Constants.mainFont,
                                       case: .uppercase,
                                       wrap: false,
                                       scale: scale
                        )
                        
                        if !icon.isEmpty { Image(systemName: icon) }
                    }
                }
                
                Divider(strokeWidth: 3)
            }
            
            .universalStyledBackgrond( condition() ? .accent : .secondary, onForeground: true)
//            .padding(.horizontal)
            
        } action: { action() }
    }
    
}

//MARK: ContextMenuButton
@available(iOS 16.0, *)
public struct ContextMenuButton: View {
    
    let title: String
    let icon: String
    let action: () -> Void
    let role: ButtonRole?
    
    public init( _ title: String, icon: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.role = role
        self.action = action
    }
    
    public var body: some View {
            
        Button(role: role, action: action) {
            Label(title, systemImage: icon)
        }
    }
}
