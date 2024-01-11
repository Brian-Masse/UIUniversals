//
//  File.swift
//  
//
//  Created by Brian Masse on 12/30/23.
//

import Foundation
import SwiftUI

///UniversalStyle is an enum representing the four core styles provided by UIUniversals. Most views / viewModifiers accept a universalStyle arg as a way to specify the style of a component.
public enum UniversalStyle: String, Identifiable {
    ///associated with the accent colors of the app
    case accent
    ///associated with the base colors of the app
    case primary
    ///associated with the secondary colors of the app
    case secondary
    ///not associated with any colors, makes materials .ultraThinMaterial
    case transparent
    
    public var id: String {
        self.rawValue
    }
}

//MARK: Colors
///The colors class is a container for default and provided colors. Base Colors and the accent Colors can be modified via the `setColors` method. The class can be extended to house additional default Colors for an application.
@available(iOS 13.0, *)
public class Colors {
    
    ///The getAccent function takes in an iOS ColorScheme and returns the corresponding accent color.
    public static func getAccent(from colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Colors.lightAccent
        case .dark: return Colors.darkAccent
        @unknown default:
            return Colors.lightAccent
        }
    }
    
    ///The getBase function takes in an iOS ColorScheme and returns the corresponding base color.
    public static func getBase(from colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Colors.baseLight
        case .dark: return Colors.baseDark
        @unknown default:
            return Colors.baseDark
        }
    }
    
    ///The getSecondaryBase function takes in an iOS ColorScheme and returns the corresponding secondary color.
    public static func getSecondaryBase(from colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light: return Colors.secondaryLight
        case .dark: return Colors.secondaryDark
        @unknown default:
            return Colors.secondaryDark
        }
    }
    
    ///the getColor function takes in a style and an iOS ColorScheme and returns the corresponding color in the right color scheme. See `UniversalStyle` for more information on which styles are associated with which colors.
    public static func getColor(from style: UniversalStyle, in colorScheme: ColorScheme) -> Color {
        switch style {
        case .primary: return getBase(from: colorScheme)
        case .secondary: return getSecondaryBase(from: colorScheme)
        case .accent: return getAccent(from: colorScheme)
        default: return Colors.lightAccent
        }
    }
    
    ///These are your apps default base colors. These show up in backgrounds of buttons, text, views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.
    public static var baseLight = makeColor( 245, 234, 208 )
    ///These are your apps default base colors. These show up in backgrounds of buttons, text, views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.
    public static var baseDark = makeColor( 0,0,0 )
    
    ///These are your apps default secondary base colors. These show up on top of the base colors but are still intended for backgrounds of views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.
    public static var secondaryLight = makeColor(220, 207, 188)
    ///These are your apps default secondary base colors. These show up on top of the base colors but are still intended for backgrounds of views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.
    public static var secondaryDark = Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.9)
    
    ///These are your apps accent colors. These show up on certain styled buttons, when typing in a TextField, or when highlighting content. You can set individual values for light and dark mode.
    public static var lightAccent = makeColor( 0, 87, 66)
    ///These are your apps accent colors. These show up on certain styled buttons, when typing in a TextField, or when highlighting content. You can set individual values for light and dark mode.
    public static var darkAccent = makeColor( 0, 87, 66)
    
    public static let yellow = makeColor(234, 169, 40)
    public static let pink = makeColor(198, 62, 120)
    public static let purple = makeColor(106, 38, 153)
    public static let grape = makeColor(70, 42, 171)
    public static let blue = makeColor(69, 121, 251)
    public static let red = makeColor(236, 81, 46)
    
    ///the makeColor function takes a red, green, and blue argument and returns a SwiftUI Color. All values are from 0 to 255. This function is entirely for convenience and to avoid using the built in rgb initializer on Color.
    public static func makeColor( _ r: CGFloat, _ g: CGFloat, _ b: CGFloat ) -> Color {
        Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    
    ///This is a publicly accessible function to change the default accent, base, and secondary colors. Each arg is a convenienceColor, which is an abstracted representation of a SwiftUI Color, but allows you to quickly initialize them with red, green, and blue channels in base 255. If an argument is left as nil, it does not change that color.
    public static func setColors( baseLight:ConvenienceColor?=nil,
                                  secondaryLight:ConvenienceColor?=nil,
                                  baseDark:ConvenienceColor?=nil,
                                  secondaryDark:ConvenienceColor?=nil,
                                  lightAccent:ConvenienceColor?=nil,
                                  darkAccent:ConvenienceColor?=nil ) {
        
        Colors.baseLight =      baseLight?.convert() ?? Colors.baseLight
        Colors.secondaryLight = secondaryLight?.convert() ?? Colors.secondaryLight
        Colors.baseDark =       baseDark?.convert() ?? Colors.baseDark
        Colors.secondaryDark =  secondaryDark?.convert() ?? Colors.secondaryDark
        
        Colors.lightAccent =    lightAccent?.convert() ?? Colors.lightAccent
        Colors.darkAccent =     darkAccent?.convert() ?? Colors.darkAccent
        
    }
    
//    This is in base 255, and is used for easily passing colors into the setColors function
    public struct ConvenienceColor {
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
///Any  custom font used by UIUniversal views, such as UniversalText,  must conform to this protocol
///`postScriptName` is the exact postScript name of the font, excluding extension
///the file name of the font should be renamed to this postscript name.
public protocol UniversalFont {
    var postScriptName: String { get }
    var fontExtension: String { get }
    static var shared: UniversalFont { get }
}

///these structs are the provided fonts in the UIUniversals package
private struct MadeTommyRegular: UniversalFont {
    static var shared: UniversalFont = MadeTommyRegular()
    
    var postScriptName: String = "MadeTommy"
    var fontExtension: String = "otf"
}

private struct RenoMono: UniversalFont {
    static var shared: UniversalFont = RenoMono()
    
    var postScriptName: String = "RenoMono-Regular"
    var fontExtension: String = "otf"
}

private struct SyneHeavy: UniversalFont {
    static var shared: UniversalFont = SyneHeavy()
    
    var postScriptName: String = "Syne-Bold"
    var fontExtension: String = "ttf"
}

///This handles font registration and access.
///`providedFonts` is the internal list of UniversalFont structures contained in this package
///`ProvidedFont` is an enum designed to make accessing those fonts easier. Structs like UniversalText take a UniversalFont; ProvidedFont provides dot syntax convenience to access those fonts. In reality each case is just a pointer to an element in the providedFonts list
/// `registerFont` reigsters a passed font. It is only required for fonts provided by the package and should not be invoked anywhere else
/// `registerFonts` should be call at the start of an app's lifecycle to register all the provided fonts
public struct FontProvider {
    private static let providedFonts: [UniversalFont] = [
        MadeTommyRegular.shared,
        RenoMono.shared,
        SyneHeavy.shared
    ]

    public enum ProvidedFont: Int, CaseIterable, Identifiable {
        case madeTommyRegular
        case renoMono
        case syneHeavy
        
        public var id: Int { self.rawValue }
        
        public func font() -> UniversalFont {
            FontProvider.providedFonts[ self.rawValue ]
        }
        
        func getUniversalFont() -> String {
            FontProvider.providedFonts[ self.rawValue ].postScriptName
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
    
    public static subscript( font: FontProvider.ProvidedFont ) -> UniversalFont {
        font.font()
    }
    
    public static var registeredDefaultFonts: Bool = false
    public static func registerFonts() {
        
        if registeredDefaultFonts { return }
        
        for font in FontProvider.providedFonts {
            let fontExtension = font.fontExtension
            
            FontProvider.registerFont(bundle: .module,
                                     fontName: font.postScriptName,
                                     fontExtension: fontExtension)
        }
        
        registeredDefaultFonts = true
    }
}


//MARK: Constants
///Constants is a container class for universal values. You can extend this class to hold more constant values for use in individual projects / views
public class Constants {
    
//    font sizes
//    These are standard fontSizes that work well with the fonts provided in UIUniversals. The variable name suggests their intended use. To see examples check out [this repo](https://github.com/Brian-Masse/UIUniversalsExample)
    public static let UILargeTextSize: CGFloat     = 130
    public static let UITitleTextSize: CGFloat     = 80
    public static let UIMainHeaderTextSize: CGFloat    = 60
    public static let UIHeaderTextSize: CGFloat    = 40
    public static let UISubHeaderTextSize: CGFloat = 30
    public static let UIDefaultTextSize: CGFloat   = 20
    public static let UISmallTextSize: CGFloat     = 15
    
//    timings
//    These are numeric representations of various common time scales. Swift measures all its time in seconds, so adding these values to date objects will produce the expected result. ie. `some date += Constants.DayTime advances the date by a day`
    public static let MinuteTime: Double = 60
    public static let HourTime: Double = 3600
    public static let DayTime: Double = 86400
    public static let WeekTime: Double = 604800
    public static let yearTime: Double = 31557600
    
//    extra
//    These are various additional constants.
    public static let UIDefaultCornerRadius: CGFloat = 40
    public static let UIBottomOfPagePadding: CGFloat = 130
    
//    fonts
///    titleFont represents the font to be used across all titles in your app. It can be set using `setDefaultFonts`
    public static var titleFont: UniversalFont = FontProvider[ .madeTommyRegular ]
    
    ///mainFont represents the font to be used in all non-title or heading texts in your app. It can be set using `setDefaultFonts`
    public static var mainFont: UniversalFont = FontProvider[ .madeTommyRegular ]
    
    ///this function allows you to set different provided fonts, or custom fonts as the title / main font of your application. You can invoke main / title Fonts with the constants class.
    public static func setDefaultFonts( mainFont: UniversalFont? = nil, titleFont: UniversalFont? = nil ) {
        Constants.titleFont = titleFont ?? Constants.titleFont
        Constants.mainFont = mainFont ?? Constants.mainFont
        
    }
    
    
//    if there are any variables that need to be computed at the start, run their setup code here
    @MainActor
    static func setupConstants() {
    }
}
