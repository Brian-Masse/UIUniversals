//
//  File.swift
//  
//
//  Created by Brian Masse on 12/30/23.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public class Colors {
//    static var tint: Color { PlanterModel.shared.activeColor }
    public static var main: Color { lightAccent }
    
    public static var colorOptions: [Color] = [ lightAccent, blue, purple, grape, pink, red, yellow,  ]
    
    public static var baseLight = makeColor( 245, 234, 208 )
    public static var secondaryLight = makeColor(220, 207, 188)
    public static var baseDark = makeColor( 0,0,0 )
    public static var secondaryDark = Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.9)
    
    public static var lightAccent = makeColor(245, 87, 66)
    public static var darkAccent = makeColor( 245, 87, 66)
    
    public static let yellow = makeColor(234, 169, 40)
    public static let pink = makeColor(198, 62, 120)
    public static let purple = makeColor(106, 38, 153)
    public static let grape = makeColor(70, 42, 171)
    public static let blue = makeColor(69, 121, 251)
    public static let red = makeColor(236, 81, 46)
    
    private static func makeColor( _ r: CGFloat, _ g: CGFloat, _ b: CGFloat ) -> Color {
        Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    
    public static func setColors( baseLight:Color?=nil, secondaryLight:Color?=nil, baseDark:Color?=nil, secondaryDark:Color?=nil, lightAccent:Color?=nil, darkAccent:Color?=nil ) {
        
        Colors.baseLight = baseLight ?? Colors.baseLight
        Colors.secondaryLight = secondaryLight ?? Colors.secondaryLight
        Colors.baseDark = baseDark ?? Colors.baseDark
        Colors.secondaryDark = secondaryDark ?? Colors.secondaryDark
        
        Colors.lightAccent = lightAccent ?? Colors.lightAccent
        Colors.darkAccent = darkAccent ?? Colors.darkAccent
        
    }
}
