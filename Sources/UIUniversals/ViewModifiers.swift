//
//  ViewModifiers.swift
//  Recall
//
//  Created by Brian Masse on 7/14/23.
//

import Foundation
import SwiftUI

let inDev: Bool = false

//MARK: UniversalBackground
@available(iOS 15.0, *)
private struct UniversalBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    let style: UniversalStyle
    let padding: CGFloat
    let color: Color?
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                content
                    .padding( padding )
                    .background(
                        Rectangle()
                            .foregroundStyle(.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                content.hideKeyboard()
                            }
                    )
                    .ignoresSafeArea(.container, edges: .bottom)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .if(color == nil) { view in view.background(Colors.getColor(from: style, in: colorScheme))  }
            .if(color != nil) { view in view.background(color!) }
        }
    }
}

@available(iOS 15.0, *)
public extension View {
    ///universalBackground applies a specific color to any view it is attached to. It always fills the frame and ignores the safe areas. The content will still respect safe areas. On any given navigation screen, there should only be one view with .universalBackground.
    func universalBackground(style: UniversalStyle = .primary,
                             padding: CGFloat = 0,
                             color: Color? = nil) -> some View {
        modifier(UniversalBackground( style: style,padding: padding, color: color))
    }
}

//MARK: UniversalImage Background
@available(iOS 15.0, *)
private struct UniversalImageBackground: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    let image: Image
    
    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 30)
                        .clipped()
                        .ignoresSafeArea()
                    
                    Colors.getSecondaryBase(from: colorScheme)
                        .opacity( colorScheme == .light ? 0.55 : 0.85)
                        .ignoresSafeArea()
                }
            }
    }
}

@available(iOS 15.0, *)
public extension View {
    ///universalImageBackground uses a specified SwiftUI Image for the background. The image is blurred, and a light or dark overlay is applied depending on the system colorScheme. It always fills the frame and ignores safe areas. The content will still respect safe areas. On any given navigation sreen, there should only be one view with .universalImageBackground.
    func universalImageBackground(_ image: Image) -> some View {
        modifier( UniversalImageBackground(image: image) )
    }
}


//MARK: UniversalTextStyle
@available(iOS 15.0, *)
private struct UniversalTextStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    let reversed: Bool
    
    private func lightColor() -> Color { reversed ? .white : .black }
    private func darkColor() -> Color { reversed ? .black : .white }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(colorScheme == .light ? lightColor() : darkColor())
    }
}

@available(iOS 15.0, *)
public extension View {
    ///universalTextStyle dynamically changes the foreground style of the view it is applied to. By default its black when the system is in lightMode and white when the system is in darkMode. Although it is called universalTextStyle, it is intended to be used on views other than SwiftUI Text, to match the default behavior of text.
    func universalTextStyle(reversed: Bool = false) -> some View {
        modifier(UniversalTextStyle( reversed: reversed ))
    }
}

//MARK: UniversalTextField
@available(iOS 15.0, *)
private struct UniversalTextField: ViewModifier {
    @Environment( \.colorScheme ) var colorScheme
        
    let font: UniversalFont
    
    func body(content: Content) -> some View {
        content
            .tint(Colors.getAccent(from: colorScheme) )
            .font(Font.custom(FontProvider.ProvidedFont.renoMono.getUniversalFont(), size: Constants.UIDefaultTextSize))
    }
}

@available(iOS 15.0, *)
public extension View {
    ///universalTextField styles a given textField with the apps accent color, which changes depending on the system ColorScheme, and with a custom font.
    func universalTextField(_ font: UniversalFont = FontProvider[.renoMono]) -> some View {
        modifier(UniversalTextField(font: font))
    }
    
}

//MARK: Rectangular Background
@available(iOS 16.0, *)
private struct RectangularBackground: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    let style: UniversalStyle
    
    let padding: CGFloat?
    let cornerRadius: CGFloat
    var corners: UIRectCorner
    let foregroundColor: Color?
    let stroke: Bool
    let strokeWidth: CGFloat
    let texture: Bool
    let shadow: Bool
    let reverseStyle: Bool

    func body(content: Content) -> some View {
        content
            .if(padding == nil) { view in view.padding() }
            .if(padding != nil) { view in view.padding(padding!) }
            .background(
                VStack {
                    if texture {
                        universalImage("papernoise")
                            .resizable()
                            .blendMode( colorScheme == .light ? .multiply : .lighten)
                            .opacity( colorScheme == .light ? 0.55 : 0.20)
                            .ignoresSafeArea()
                            .allowsHitTesting(false)
                    }
                }
            )
            .if( foregroundColor != nil ) { view in view.foregroundStyle(foregroundColor!)}
            .universalStyledBackgrond(style, reversed: reverseStyle)
            .if(stroke) { view in
                view
                    .overlay(
                        RoundedCorner(radius: cornerRadius,
                                      corners: corners)
                            .stroke(colorScheme == .dark ? .white : .black, lineWidth: strokeWidth)
                    )
            }
            .if(corners == .allCorners) { view in view.cornerRadius(cornerRadius)}
            .if(corners != .allCorners) { view in view.cornerRadius(cornerRadius, corners: corners)}
            .if(shadow) { view in
                view
                    .shadow(color: .black.opacity(0.2),
                            radius: 10,
                            y: 5)
            }
    }
}

@available(iOS 16.0, *)
public extension View {
    ///rectangularBackground applies a stylized background to any view it is attached to. By default it contains padding, rounded corners, and uses the .primary UniversalStyle.
    func rectangularBackground(_ padding: CGFloat? = nil,
                               style: UniversalStyle = .primary,
                               foregroundColor: Color? = nil,
                               stroke: Bool = false,
                               strokeWidth: CGFloat = 1,
                               cornerRadius: CGFloat = Constants.UIDefaultCornerRadius,
                               corners: UIRectCorner = .allCorners,
                               texture: Bool = false,
                               shadow: Bool = false,
                               reverseStyle: Bool = false) -> some View {
        
        modifier(RectangularBackground(style: style,
                                       padding: padding,
                                       cornerRadius: cornerRadius,
                                       corners: corners,
                                       foregroundColor: foregroundColor,
                                       stroke: stroke,
                                       strokeWidth: strokeWidth,
                                       texture: texture,
                                       shadow: shadow,
                                      reverseStyle: reverseStyle))
    }
}


//MARK: RoundedCorners
@available(iOS 15.0, *)
private struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

@available(iOS 15.0, *)
public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}



//MARK: Utilities
@available(iOS 15.0, *)
private struct BecomingVisible: ViewModifier {
    @State var action: (() -> Void)?

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: VisibleKey.self,
                        // See discussion!
                        value: UIScreen.main.bounds.intersects(proxy.frame(in: .global))
                    )
                    .onPreferenceChange(VisibleKey.self) { isVisible in
                        guard isVisible, let action else { return }
                        action()
                    }
            }
        }
    }

    struct VisibleKey: PreferenceKey {
        static var defaultValue: Bool = false
        static func reduce(value: inout Bool, nextValue: () -> Bool) { }
    }
}

@available(iOS 15.0, *)
private struct DefaultAlert: ViewModifier {
    
    @Binding var activate: Bool
    let title: String
    let description: String
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $activate) { } message: {
                Text( description )
            }
    }
}

@available(iOS 15.0, *)
public extension View {
    func defaultAlert(_ binding: Binding<Bool>, title: String, description: String) -> some View {
        modifier( DefaultAlert(activate: binding, title: title, description: description) )
    }
    
    func withoutAnimation(action: @escaping () -> Void) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            action()
        }
    }
    
    ///onBecomingVisible fires an action every time a view appears on the visible screen. As opposed to .onAppear() which only runs once the first time a view appears on screen, onVisible fires each time a view re-enters the screen.
    func onBecomingVisible(perform action: @escaping () -> Void) -> some View {
        modifier(BecomingVisible(action: action))
    }
    
    #if canImport(UIKit)
    ///the hideKeyboard extension on View minimizes the default iOS keyboard. It can called from a tap gesture, swipe gesture, or any other type of gesture to naturally dismiss the keyboard when a user focuses on another piece of content.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif

    ///The if extension on View creates a conditional modifier, that applies a unique style when a certain condition is met. It automatically refreshes when the condition changes.
    @ViewBuilder
    func `if`<Content: View>( _ condition: Bool, contentBuilder: (Self) -> Content ) -> some View {
        if condition {
            contentBuilder(self)
        } else { self }
    }
}


//MARK: Colors
@available(iOS 15.0, *)
private struct UniversalforegroundStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle( Colors.getAccent(from: colorScheme) )
    }
}

@available(iOS 15.0, *)
private struct UniversalBackgroundColor: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    let ignoreSafeAreas: Edge.Set?
    
    func body(content: Content) -> some View {
        content
            .if(ignoreSafeAreas == nil ) { view in view.background(Colors.getAccent(from: colorScheme)) }
            .if(ignoreSafeAreas != nil ) { view in view.background(Colors.getAccent(from: colorScheme), ignoresSafeAreaEdges: ignoreSafeAreas!) }
            
    }
}

@available(iOS 15.0, *)
private struct UniversalStyledBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    let style: UniversalStyle
    let color: Color?
    let foregrond: Bool
    let reversed: Bool
    
    func body(content: Content) -> some View {
        if !foregrond {
            content
                .if( style == .transparent ) { view in view.background( .ultraThinMaterial ) }
                .if( style != .transparent ) { view in view.background( color ?? Colors.getColor(from: style, in: colorScheme, reversed: reversed) ) }
        } else {
            content
                .if( style == .transparent ) { view in view.foregroundStyle( .ultraThinMaterial ) }
                .if( style != .transparent ) { view in view.foregroundStyle( color ?? Colors.getColor(from: style, in: colorScheme, reversed: reversed) ) }
        }
    }
}

@available(iOS 15.0, *)
public extension View {
    ///universalForegroundStyle sets the foregroundStyle of a view to the correct accent color of the app depending on the system colorScheme. When the colorScheme changes, this viewModifier automatically updates the foregroundStyle with the correct color. It is not publicly accessible.
    private func universalforegroundStyle() -> some View {
        modifier( UniversalforegroundStyle() )
    }
    
    ///universalBackgroundStyle sets the background of a view to the correct accent color of the app depending on the system colorScheme. When the colorScheme changes, this viewModifier automatically updates the foregroundStyle with the correct color. It is not publicly accessible.
    private func universalBackgroundColor(ignoreSafeAreas: Edge.Set? = nil) -> some View {
        modifier( UniversalBackgroundColor(ignoreSafeAreas: ignoreSafeAreas) )
    }
    
    ///universalStyledBackground sets the background of a view to the correct color depending on the specified UniversalStyle and the system ColorScheme. It can also take a custom color to apply to the background. You can also to use these colors on the foreground of the view. When the colorScheme changes, this viewModifier automatically updates the style with the correct color. This modifier should be used instead of universalBackgroundColor or universalForegroundColor
    func universalStyledBackgrond( _ style: UniversalStyle,
                                   color: Color? = nil,
                                   onForeground: Bool = false,
                                   reversed: Bool = false) -> some View {
        modifier( UniversalStyledBackground(style: style, color: color, foregrond: onForeground, reversed: reversed) )
    }
}
