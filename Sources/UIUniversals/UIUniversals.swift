// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct TestView: View {

    public init() { 
        print("this is runnign here")
        ProvidedFont.registerFonts()
    }
    
    public var body: some View {
        HStack {
            Text("hello world!")
//                .font(.custom( ProvidedFont.renoMono.rawValue, size: 50))
            
            Image(systemName: "globe.europe.africa")
        }
        .foregroundStyle(Colors.lightAccent)
    }
}


@available(iOS 15.0, *)
#Preview {
    TestView()
}
