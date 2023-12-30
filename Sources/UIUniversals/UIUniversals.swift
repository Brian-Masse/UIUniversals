// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public struct TestView: View {
    
    public var body: some View {
        HStack {
            Text("hello world!")
            
            Image(systemName: "globe.europe.africa")
        }
    }
}
