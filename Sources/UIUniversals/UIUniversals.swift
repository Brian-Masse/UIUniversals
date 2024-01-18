// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@available(iOS 16.0, *)
private struct TestView: View {
    
    struct TestData: Identifiable, Equatable {
        var data: String = ""
        let uuid: UUID = UUID()
        
        var id: UUID {
            self.uuid
        }
        
        init() {
            let random = Int.random(in: 0...6)
            for _ in 0...random {
                data += "0"
            }
        }
    }
    
    private func makeRandomData() -> [TestData] {
        var list: [TestData] = []
        for _ in 0...30 { list.append(TestData()) }
        return list
    }
    
    @State var scrollPoint: CGPoint = .zero
    
    var body: some View {
        
        let data = makeRandomData()
        
        ScrollReader($scrollPoint) {
            VStack {
                HStack {
                    UniversalText( "Hello World!",
                                   size: Constants.UISubHeaderTextSize,
                                   font: FontProvider[.syneHeavy] )
                    
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
                .padding(.bottom)
                
                Divider()
                
                WrappedHStack(collection: data, spacing: 5) { obj in
                    UniversalText( obj.data, size: Constants.UIDefaultTextSize, font: FontProvider[.renoMono] )
                        .rectangularBackground(7, style: .secondary, stroke: true)
                }
                
                Divider()
                
                Spacer()
                
                UniversalText( "\(scrollPoint.y)", size: Constants.UIDefaultTextSize, font: FontProvider[.renoMono] )
            }
            .padding()
        }
        .universalTextStyle(reversed: false)
        .universalImageBackground( universalImage("test") )
    }
}

@available(iOS 16.0, *)
#Preview {
    TestView()
}


//MARK: UniversalText
///UniversalText is a super charged type of SwiftUI Text. By Default it accepts rigid sizing and custom fonts, but boasts a number of other sizing, scaling, and position features. All basic text viewModifiers such as .foregroundStyle, or .rotationEffect still work on it. It is recommended that any project adopting UIUniversal use UniversalText for all instances of text.
@available(iOS 15.0, *)
public struct UniversalText: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    let text: String
    let size: CGFloat
    let font: String
    let textCase: Text.Case?
    
    let wrap: Bool
    let fixed: Bool
    let scale: Bool
    
    let alignment: TextAlignment
    let lineSpacing: CGFloat
    let compensateForEmptySpace: Bool
    
    public init(_ text: String,
                size: CGFloat,
                font: UniversalFont = FontProvider[.madeTommyRegular],
                case textCase: Text.Case? = nil,
                wrap: Bool = true,
                fixed: Bool = false,
                scale: Bool = false,
                textAlignment: TextAlignment = .leading,
                lineSpacing: CGFloat = 0.5,
                compensateForEmptySpace: Bool = true
    ) {
        self.text = text
        self.size = size
        self.font = font.postScriptName
        self.textCase = textCase
        
        self.wrap = wrap
        self.fixed = fixed
        self.scale = scale
        
        self.alignment = textAlignment
        self.lineSpacing = lineSpacing
        self.compensateForEmptySpace = compensateForEmptySpace
    }
    
    @ViewBuilder
    private func makeText(_ text: String) -> some View {
        
        Text(text)
            .dynamicTypeSize( ...DynamicTypeSize.accessibility1 )
            .lineSpacing(lineSpacing)
            .minimumScaleFactor(scale ? 0.1 : 1)
            .lineLimit(wrap ? 30 : 1)
            .multilineTextAlignment(alignment)
            .font( fixed ? Font.custom(font, fixedSize: size) : Font.custom(font, size: size) )
            .if( textCase != nil ) { view in view.textCase(textCase) }
        
    }
    
    private func translateTextAlignment() -> HorizontalAlignment {
        switch alignment {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }
    
    public var body: some View {
        
        if lineSpacing < 0 {
            let texts = text.components(separatedBy: "\n")
            
            VStack(alignment: translateTextAlignment(), spacing: 0) {
                ForEach(0..<texts.count, id: \.self) { i in
                    makeText(texts[i])
                        .offset(y: CGFloat( i ) * lineSpacing )
                }
            }
            .padding(.bottom, (Double(texts.count - 1) * lineSpacing) )
        } else {
            makeText(text)
        }
    }
}

//MARK: ResizeableIcon
///ResizableIcon creates an SFSymbol icon at the desired size. It is recommended to be used in combination with UniversalText of the same size. For similar reasons, it is recommended you use one of the default sizes provided in Constants for consistent sizing with other icons and UniversalText.
@available(iOS 15.0, *)
public struct ResizableIcon: View {
    let icon: String
    let size: CGFloat
    
    public init( _ icon: String, size: CGFloat ) {
        self.icon = icon
        self.size = size
    }
    
    public var body: some View {
        Image(systemName: icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: size)
    }
}

//MARK: AsyncLoader
///AsyncLoader runs a batch of async code, and waits on its completion before loading a view. It is useful if a view depends on certain information to be fetched before it can properly display its content. While it is waiting, asyncLoader displays a progress view. It is not recommended to put a full page in an AsyncLoader as it may lead to an unresponsive feeling app. Instead only wrap individual components in the loader.
@available(iOS 15.0, *)
public struct AsyncLoader<Content>: View where Content: View {
    @Environment(\.scenePhase) private var scenePhase
    
    let block: () async -> Void
    let content: Content
    
    @State var loading: Bool = true
    
    public init( block: @escaping () async -> Void, @ViewBuilder content: @escaping () -> Content ) {
        self.content = content()
        self.block = block
    }

    public var body: some View {
        VStack{
            if loading {
                ProgressView() .task {
                        await block()
                        loading = false
                    }
            } else if scenePhase != .background && scenePhase != .inactive { content }
        }
        .onBecomingVisible { loading = true }
    .onChange(of: scenePhase) { newValue in
            if newValue == .active { loading = true }
        }
    }
}

//MARK: Wrapped HStack
///WrappedHStack is a container that holds variably sized items in a grid format. Instead of having equal spacing that is either filled up by content or white space,  WrappedHStack arranges items horizontally until it reaches the edge of the screen, where it then creates a new line of content.
@available(iOS 15.0, *)
public struct WrappedHStack<Content: View, Object: Identifiable>: View where Object: Equatable {
    
    @State var size: CGSize = .zero
    
    let collection: [Object]
    let content: ( Object ) -> Content
    let spacing: CGFloat

    public  init( collection: [Object], spacing: CGFloat = 10,  @ViewBuilder content: @escaping (Object) -> Content ) {
        self.collection = collection
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        var previousRowHeight: CGFloat = 0
        
        GeometryReader { geo in
            SubViewGeometryReader(size: $size) {
                ZStack(alignment: .leading) {
                    ForEach( collection ) { object in
                        
                        content(object)
                            .alignmentGuide(HorizontalAlignment.leading) { d in
                                if abs(geo.size.width + width) < d.width {
                                    width = 0
                                    height -= (previousRowHeight + spacing)
                                    previousRowHeight = 0
                                }
                                previousRowHeight = max(d.height, previousRowHeight)
                                let offSet = width
                                if collection.last == object { width = 0 }
                                else { width -= (d.width + spacing) }
                                
                                return offSet
                            }
                            .alignmentGuide(VerticalAlignment.center) { d in
                                let offset = height + (d.height / 2)
                                if collection.last == object { height = 0 }
                                
                                return offset
                            }
                    }
                }
            }
        }
        .frame(height: size.height)
    }
}

@available(iOS 15.0, *)
private struct SubViewGeometryReader<Content: View>: View {
    @Binding var size: CGSize
    let content: () -> Content
    
    init( size: Binding<CGSize>, contentBuilder: @escaping () -> Content ) {
        self._size = size
        self.content = contentBuilder
    }
    
    var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.size = preferences
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

//MARK: Divider
///Divider creates a horizontal or vertical line that fills all the available space to divide pieces of content.
@available(iOS 15.0, *)
public struct Divider: View {
    
    let vertical: Bool
    let strokeWidth: CGFloat
    let color: Color
    
    public init(vertical: Bool = false, strokeWidth: CGFloat = 1, color: Color = .black) {
        self.vertical = vertical
        self.strokeWidth = strokeWidth
        self.color = color
    }
    
    public var body: some View {
        Rectangle()
            .if(vertical) { view in view.frame(width: strokeWidth) }
            .if(!vertical) { view in view.frame(height: strokeWidth) }
//            .foregroundStyle(color)
    }
}

//MARK: ScrollReader
private struct SrollReaderPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

///ScrollReader wraps around vertically aligned content, puts them into a scrollView, and reads back the position of the scroll to a CGPoint.
@available(iOS 15.0, *)
public struct ScrollReader<C: View>: View {
    
    var positionBinding: Binding<CGPoint>
    let content: C
    
    public init( _ position: Binding<CGPoint>, contentBuilder: () -> C ) {
        self.positionBinding = position
        self.content = contentBuilder()
    }
    
    let coordinateSpaceName = "scrollReader"
    
    public var body: some View {
        ScrollView {
            content
                .background( GeometryReader { geo in
                    Color.clear
                        .preference(key: SrollReaderPreferenceKey.self,
                                    value: geo.frame(in: .named(coordinateSpaceName)).origin)
                } )
                .onPreferenceChange(SrollReaderPreferenceKey.self) { value in
                    withAnimation { self.positionBinding.wrappedValue = value }
                }
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}

//MARK: BlurScroll
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}


///BlurScroll wraps around vertically aligned content, puts them into a scrollView, and applies a fixed blur at the bottom of the screen. This gives the effect that the content is scrolling into or out of the blur depending on the direction. The Blur effect ignores safe Areas.
@available(iOS 15.0, *)
public struct BlurScroll<C: View>: View {
    
    let blur: CGFloat
    let blurHeight: CGFloat
    
    let coordinateSpaceName = "scroll"
    
    let content: C
    
    var scrollPositionBinding: Binding<CGPoint>
    @State var scrollPosition: CGPoint = .zero
    
    public init(_ blur: CGFloat, blurHeight: CGFloat = 0.25, scrollPositionBinding: Binding<CGPoint>? = nil, contentBuilder: () -> C) {
        
        self.blur = blur
        self.blurHeight = blurHeight
        
        self.content = contentBuilder()
        self.scrollPositionBinding = Binding { .zero } set: { _ in }
        self.scrollPositionBinding = scrollPositionBinding == nil ? defaultPositionBinding : scrollPositionBinding!
        
    }
    
    private var defaultPositionBinding: Binding<CGPoint> {
        Binding { scrollPosition } set: { newValue in
            withAnimation { scrollPosition = newValue }
        }
    }
    
    private let gradient = LinearGradient(stops: [
        .init(color: .white, location: 0.10),
        .init(color: .clear, location: 0.25)],
                                  startPoint: .bottom,
                                  endPoint: .top)
    
    private let invertedGradient = LinearGradient(stops: [
        .init(color: .clear, location: 0.10),
        .init(color: .white, location: 0.25)],
                                          startPoint: .bottom,
                                          endPoint: .top)
    
    private var offset: CGFloat {
        scrollPositionBinding.wrappedValue.y
    }
    
    public var body: some View {
        
        GeometryReader { topGeo in
            
            ScrollReader(scrollPositionBinding) {
            
                ZStack(alignment: .top) {
                    content
                        .mask(
                            VStack {
                                invertedGradient
                                
                                    .frame(height: topGeo.size.height, alignment: .top)
                                    .offset(y:  -self.offset )
                                Spacer()
                            }
                        )
                    
                    content
                        .blur(radius: 15)
                        .frame(height: topGeo.size.height, alignment: .top)
                        .mask(gradient
                            .frame(height: topGeo.size.height)
                            .offset(y:  -self.offset )
                        )
                        .ignoresSafeArea()
                }
                .padding(.bottom, topGeo.size.height * 0.25)
            }
        }
        .ignoresSafeArea()
    }
}

//MARK: Universal Image
@available(iOS 15.0, *)
public func universalImage(_ name: String) -> Image {
    if let UIImage = UIImage(named: name, in: .module, with: nil) {
        return Image(uiImage: UIImage )
    }
    return Image( "papernoise" )
}

extension String: Identifiable {
    public var id: String {
        self
    }
}

//MARK: Vertical Layout
@available(iOS 16.0, *)
struct VerticalLayout: Layout {
    public init() {}
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = subviews.first!.sizeThatFits(.unspecified)
        return .init(width: size.height, height: size.width)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first!.place(at: .init(x: bounds.midX, y: bounds.midY), anchor: .center, proposal: .unspecified)
    }
}

///RotatedLayout rotates the frame of a given view by a specified angle. This is useful if you want to more closely match the frame of a view with a `.rotationEffect`. In plain SwiftUI, a `.rotationEffect` does not change the frame at all, creating a mismatch between what is seen on screen and what is handled in layouting.
@available(iOS 16.0, *)
public struct RotatedLayout: Layout {
    //    radians
    let angle: Double
    let scale: Double
    
    public init( at angle: Double, scale: Double = 1 ) {
        self.angle = abs(angle)
        self.scale = scale
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = subviews.first!.sizeThatFits(.unspecified)
        let width = size.width * cos(Double(angle)) + size.height * sin(Double(angle))
        let height = size.height * cos(Double(angle)) + size.width * sin(Double(angle))
        
        return .init(width: width * scale,
                     height: height * scale)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first!.place(at: .init(x: bounds.midX, y: bounds.midY), anchor: .center, proposal: .unspecified)
    }
}
