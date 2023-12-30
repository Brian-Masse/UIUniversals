// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct TestView: View {

    public init() {
        ProvidedFont.registerFonts()
    }
    
    public var body: some View {
        HStack {
            Text("hello world!")
                .font(.custom( ProvidedFont.syneHeavy.rawValue, size: 50))
            
            Image(systemName: "globe.europe.africa")
        }
        .foregroundStyle(Colors.lightAccent)
    }
}

@available(iOS 15.0, *)
public func universalImage(_ name: String) -> Image {
    if let UIImage = UIImage(named: name, in: .module, with: nil) {
        return Image(uiImage: UIImage )
    }
    return Image( "papernoise" )
}


@available(iOS 15.0, *)
#Preview {
    TestView()
}
