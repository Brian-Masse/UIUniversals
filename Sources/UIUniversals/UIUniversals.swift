// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct TestView: View {

    public init() {  }
    
    public var body: some View {
        HStack {
            Text("hello world!")
            
            Image(systemName: "globe.europe.africa")
        }
        .foregroundStyle(Colors.lightAccent)
    }
}


@available(iOS 15.0, *)
#Preview {
    TestView()
}
