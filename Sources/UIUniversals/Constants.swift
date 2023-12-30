//
//  File.swift
//  
//
//  Created by Brian Masse on 12/30/23.
//

import Foundation
import SwiftUI

//MARK: Colors
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
    
    static func makeColor( _ r: CGFloat, _ g: CGFloat, _ b: CGFloat ) -> Color {
        Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    
    public static func setColors( baseLight:convenienceColor?=nil,
                                  secondaryLight:convenienceColor?=nil,
                                  baseDark:convenienceColor?=nil,
                                  secondaryDark:convenienceColor?=nil,
                                  lightAccent:convenienceColor?=nil,
                                  darkAccent:convenienceColor?=nil ) {
        
        Colors.baseLight =      baseLight?.convert() ?? Colors.baseLight
        Colors.secondaryLight = secondaryLight?.convert() ?? Colors.secondaryLight
        Colors.baseDark =       baseDark?.convert() ?? Colors.baseDark
        Colors.secondaryDark =  secondaryDark?.convert() ?? Colors.secondaryDark
        
        Colors.lightAccent =    lightAccent?.convert() ?? Colors.lightAccent
        Colors.darkAccent =     darkAccent?.convert() ?? Colors.darkAccent
        
    }
    
//    This is in base 255, and is used for easily passing colors into the setColors function
    public struct convenienceColor {
        let red: CGFloat
        let blue: CGFloat
        let green: CGFloat
        
        public init( _ red: CGFloat, _ blue: CGFloat, green: CGFloat) {
            self.red = red
            self.blue = blue
            self.green = green
        }
        
        public func convert() -> Color {
            Colors.makeColor(self.red,
                             self.green,
                             self.blue)
        }
    }
}

//MARK: ProvidedFonts

public enum ProvidedFont: String, CaseIterable, Identifiable {
    
    public static var registeredDefaultFonts: Bool = false
    
    case madeTommyRegular = "MadeTommy"
    case renoMono = "RenoMono-Regular"
    case syneHeavy = "Syne-Bold"
    
    private func getExtension() -> String {
        switch self {
        case .syneHeavy: return "ttf"
        default: return "otf"
        }
    }
    
    public var id: String {
        self.rawValue
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
    public static func registerFonts() {
        
        if registeredDefaultFonts { return }
        
        for font in ProvidedFont.allCases {
            let fontExtension = font.getExtension()
            
            ProvidedFont.registerFont(bundle: .module,
                                      fontName: font.rawValue,
                                      fontExtension: fontExtension)
        }
        
        registeredDefaultFonts = true
    }
}

//MARK: Constants
class Constants {
    
    //    font sizes
    static let UILargeTextSize: CGFloat     = 130
    static let UITitleTextSize: CGFloat     = 80
    static let UIMainHeaderTextSize: CGFloat    = 60
    static let UIHeaderTextSize: CGFloat    = 40
    static let UISubHeaderTextSize: CGFloat = 30
    static let UIDefaultTextSize: CGFloat   = 20
    static let UISmallTextSize: CGFloat     = 15
    
    //    extra
    static let UIDefaultCornerRadius: CGFloat = 40
    static let UILargeCornerRadius: CGFloat = 55
    static let UIBottomOfPagePadding: CGFloat = 130
    
    //    forms
    static let UIFormSpacing      : CGFloat = 10
    static let UIFormPagePadding: CGFloat = 5
    static let UIFormSliderTextFieldWidth: CGFloat = 60
    
    
    //    timings
    static let MinuteTime: Double = 60
    static let HourTime: Double = 3600
    static let DayTime: Double = 86400
    static let WeekTime: Double = 604800
    static let yearTime: Double = 31557600
    
    //    fonts
//    static let titleFont: ProvidedFont = .madeTommyRegular
//    static let mainFont: ProvidedFont = .madeTommyRegular
    
    
    //    if there are any variables that need to be computed at the start, run their setup code here
    @MainActor
    static func setupConstants() {
    }
}
