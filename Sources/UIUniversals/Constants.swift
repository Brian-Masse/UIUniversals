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
    public static var tint: Color { Colors.main }
    public static var main: Color { lightAccent }
    
    public static var colorOptions: [Color] = [ lightAccent, blue, purple, grape, pink, red, yellow,  ]
    
    public static func getAccent(from colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Colors.lightAccent
        case .dark: return Colors.darkAccent
        @unknown default:
            return Colors.lightAccent
        }
    }
    
    public static func getBase(from colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Colors.baseLight
        case .dark: return Colors.baseDark
        @unknown default:
            return Colors.baseDark
        }
    }
    
    public static func getSecondaryBase(from colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Colors.secondaryLight
        case .dark: return Colors.secondaryDark
        @unknown default:
            return Colors.secondaryDark
        }
    }
    
    public static func getColor(from style: UniversalStyle, in colorScheme: ColorScheme) -> Color {
        switch style {
        case .primary: return getBase(from: colorScheme)
        case .secondary: return getSecondaryBase(from: colorScheme)
        case .accent: return getAccent(from: colorScheme)
        default: return Colors.lightAccent
        }
    }
    
    public static var baseLight = makeColor( 245, 234, 208 )
    public static var secondaryLight = makeColor(220, 207, 188)
    public static var baseDark = makeColor( 0,0,0 )
    public static var secondaryDark = Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.9)
    
    public static var lightAccent = makeColor( 0, 87, 66)
    public static var darkAccent = makeColor( 0, 87, 66)
    
    public static let yellow = makeColor(234, 169, 40)
    public static let pink = makeColor(198, 62, 120)
    public static let purple = makeColor(106, 38, 153)
    public static let grape = makeColor(70, 42, 171)
    public static let blue = makeColor(69, 121, 251)
    public static let red = makeColor(236, 81, 46)
    
    public static func makeColor( _ r: CGFloat, _ g: CGFloat, _ b: CGFloat ) -> Color {
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
///for any custom font to be used by UIUniversal views, such as UniversalText, they must be a struct
///conforming to this protocol
///`postScriptName` is the exact postScript name of the font, excluding extension
///the file name of the font should be renamed to this postscript name.
public protocol UniversalFont {
    var postScriptName: String { get }
    var fontExtension: String { get }
}

///these structs are the provided fonts in the UIUniversals package
private struct MadeTommyRegular: UniversalFont {
    var postScriptName: String = "MadeTommy"
    var fontExtension: String = "otf"
}

private struct RenoMono: UniversalFont {
    var postScriptName: String = "RenoMono-Regular"
    var fontExtension: String = "otf"
}

private struct SyneHeavy: UniversalFont {
    var postScriptName: String = "Syne-Bold"
    var fontExtension: String = "ttf"
}

///This handles font registration and access.
///`providedFonts` is the internal list of UniversalFont structures contained in this package
///`ProvidedFont` is an enum designed to make accessing those fonts easier. Struct slike UniversalText take a ProvidedFont as an input to get dot syntax conveniencel. In reality they are just pointers to elements in the providedFonts list
/// `registerFont` reigsters a passed font. It is only required for fonts provided by the package and should not be invoked anywhere else
/// `registerFonts` should be call at the start of an app's lifecycle to register all the provided fonts
public struct FontManager {
    private static let providedFonts: [UniversalFont] = [
        MadeTommyRegular(),
        RenoMono(),
        SyneHeavy()
    ]

    public enum ProvidedFont: Int, CaseIterable, Identifiable {
        case madeTommyRegular
        case renoMono
        case syneHeavy
        
        public var id: Int { self.rawValue }
        
        func getUniversalFont() -> String {
            FontManager.providedFonts[ self.rawValue ].postScriptName
        }
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
    
    public static var registeredDefaultFonts: Bool = false
    public static func registerFonts() {
        
        if registeredDefaultFonts { return }
        
        for font in FontManager.providedFonts {
            let fontExtension = font.fontExtension
            
            FontManager.registerFont(bundle: .module,
                                     fontName: font.postScriptName,
                                     fontExtension: fontExtension)
        }
        
        registeredDefaultFonts = true
    }
}


//MARK: Constants
public class Constants {
    
    //    font sizes
    public static let UILargeTextSize: CGFloat     = 130
    public static let UITitleTextSize: CGFloat     = 80
    public static let UIMainHeaderTextSize: CGFloat    = 60
    public static let UIHeaderTextSize: CGFloat    = 40
    public static let UISubHeaderTextSize: CGFloat = 30
    public static let UIDefaultTextSize: CGFloat   = 20
    public static let UISmallTextSize: CGFloat     = 15
    
    //    extra
    public static let UIDefaultCornerRadius: CGFloat = 40
    public static let UILargeCornerRadius: CGFloat = 55
    public static let UIBottomOfPagePadding: CGFloat = 130
    
    //    forms
    public static let UIFormSpacing      : CGFloat = 10
    public static let UIFormPagePadding: CGFloat = 5
    public static let UIFormSliderTextFieldWidth: CGFloat = 60
    
    
    //    timings
    public static let MinuteTime: Double = 60
    public static let HourTime: Double = 3600
    public static let DayTime: Double = 86400
    public static let WeekTime: Double = 604800
    public static let yearTime: Double = 31557600
    
    //    fonts
    public static let titleFont: FontManager.ProvidedFont = .madeTommyRegular
    public static let mainFont: FontManager.ProvidedFont = .madeTommyRegular
    
    
    //    if there are any variables that need to be computed at the start, run their setup code here
    @MainActor
    static func setupConstants() {
    }
}
