//
//  ViewModifiers.swift
//  Recall
//
//  Created by Brian Masse on 7/14/23.
//

import Foundation
import SwiftUI

let inDev: Bool = false

@available(iOS 15.0, *)
#Preview {
    VStack {
        HStack {
            Text("hello World!")
            
            Image(systemName: "globe.americas")
            
            Spacer()
        }
        .rectangularBackground(style: .transparent, shadow: true)
        .padding(.bottom)
        
        HStack {
            Text("manual RectangularBackground")
            
            Image(systemName: "globe.europe.africa")
        }
        .padding()
        .background(
            Colors.secondaryLight
                .cornerRadius(50, corners: [ .topRight, .bottomLeft ])
                
        )
        
        Spacer()
    }
    .padding()
    .universalTextStyle(reversed: false)
    .universalImageBackground( universalImage("test") )
    
}

public enum UniversalStyle: String, Identifiable {
    case primary
    case secondary
    case transparent
    case accent
    
    public var id: String {
        self.rawValue
    }
}


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
                        .opacity(0.55)
                        .ignoresSafeArea()
                }
            }
    }
}

@available(iOS 15.0, *)
public extension View {
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
    func universalTextStyle(reversed: Bool = false) -> some View {
        modifier(UniversalTextStyle( reversed: reversed ))
    }
}

//MARK: UniversalTextField

@available(iOS 15.0, *)
private struct UniversalTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .tint(Colors.tint)
            .font(Font.custom(ProvidedFont.renoMono.rawValue, size: Constants.UIDefaultTextSize))
    }
}

@available(iOS 15.0, *)
public extension View {
    func universalTextField() -> some View {
        modifier(UniversalTextField())
    }
    
}

//MARK: Rectangular Background
@available(iOS 15.0, *)
private struct RectangularBackground: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    let style: UniversalStyle
    
    let padding: CGFloat?
    let cornerRadius: CGFloat
    let stroke: Bool
    let texture: Bool
    let shadow: Bool
    
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
            .if(style == .transparent) { view in view.background( .ultraThinMaterial ) }
            .if(style != .transparent) { view in view.background( Colors.getColor(from: style, in: colorScheme) ) }
            .if(stroke) { view in
                view
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
                    )
            }
            .cornerRadius(cornerRadius)
            .if(shadow) { view in
                view
                    .shadow(color: .black.opacity(0.2),
                            radius: 10,
                            y: 5)
            }
    }
}

@available(iOS 15.0, *)
extension View {
    func rectangularBackground(_ padding: CGFloat? = nil,
                                     style: UniversalStyle = .primary,
                                     stroke: Bool = false,
                                     cornerRadius: CGFloat = Constants.UIDefaultCornerRadius,
                                     texture: Bool = false,
                                     shadow: Bool = false) -> some View {
        
        modifier(RectangularBackground(style: style,
                                             padding: padding,
                                             cornerRadius: cornerRadius, 
                                             stroke: stroke,
                                             texture: texture,
                                             shadow: shadow))
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
private struct Developer: ViewModifier {
    func body(content: Content) -> some View {
        if inDev {
            content
        }
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
    
    func onBecomingVisible(perform action: @escaping () -> Void) -> some View {
        modifier(BecomingVisible(action: action))
    }
    
    #if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif

    
    @ViewBuilder
    func `if`<Content: View>( _ condition: Bool, contentBuilder: (Self) -> Content ) -> some View {
        if condition {
            contentBuilder(self)
        } else { self }
    }

    func developer() -> some View {
        modifier( Developer() )
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
extension View {
    func universalforegroundStyle() -> some View {
        modifier( UniversalforegroundStyle() )
    }
    
    func universalBackgroundColor(ignoreSafeAreas: Edge.Set? = nil) -> some View {
        modifier( UniversalBackgroundColor(ignoreSafeAreas: ignoreSafeAreas) )
    }
}

////MARK: Vertical Layout
//struct VerticalLayout: Layout {
//    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
//        let size = subviews.first!.sizeThatFits(.unspecified)
//        return .init(width: size.height, height: size.width)
//    }
//
//    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
//        subviews.first!.place(at: .init(x: bounds.midX, y: bounds.midY), anchor: .center, proposal: .unspecified)
//    }
//}
//
//struct RotatedLayout: Layout {
//    //    radians
//    let angle: Double
//    let scale: Double
//    
//    init( at angle: Double, scale: Double = 1 ) {
//        self.angle = abs(angle)
//        self.scale = scale
//    }
//    
//    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
//        let size = subviews.first!.sizeThatFits(.unspecified)
//        let width = size.width * cos(Double(angle)) + size.height * sin(Double(angle))
//        let height = size.height * cos(Double(angle)) + size.width * sin(Double(angle))
//        
//        return .init(width: width * scale,
//                     height: height * scale)
//    }
//
//    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
//        subviews.first!.place(at: .init(x: bounds.midX, y: bounds.midY), anchor: .center, proposal: .unspecified)
//    }
//}
