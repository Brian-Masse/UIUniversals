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

@available(iOS 13.0, *)
public extension Color {
    ///initialize a color with rgb measured from 0 to 255
    init( _ red: Double, _ green: Double, _ blue: Double ) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
}

//MARK: Colors
///The colors class is a container for default and provided colors. Base Colors and the accent Colors can be modified via the `setColors` method. The class can be extended to house additional default Colors for an application.
@available(iOS 13.0, *)
public class Colors: ObservableObject {
    
    ///The getAccent function takes in an iOS ColorScheme and returns the corresponding accent color.
    public static func getAccent(from colorScheme: ColorScheme, reversed: Bool = false) -> Color {
        switch colorScheme {
        case .light: return !reversed ? Colors.shared.lightAccent : Colors.shared.darkAccent
        case .dark: return !reversed ? Colors.shared.darkAccent : Colors.shared.lightAccent
        @unknown default:
            return Colors.shared.lightAccent
        }
    }
    
    ///The getBase function takes in an iOS ColorScheme and returns the corresponding base color.
    public static func getBase(from colorScheme: ColorScheme, reversed: Bool = false) -> Color {
        switch colorScheme {
        case .light: return !reversed ? Colors.shared.baseLight : Colors.shared.baseDark
        case .dark: return !reversed ? Colors.shared.baseDark : Colors.shared.baseLight
        @unknown default:
            return Colors.shared.baseDark
        }
    }
    
    ///The getSecondaryBase function takes in an iOS ColorScheme and returns the corresponding secondary color.
    public static func getSecondaryBase(from colorScheme: ColorScheme, reversed: Bool = false) -> Color {
        switch colorScheme {
        case .light: return !reversed ? Colors.shared.secondaryLight : Colors.shared.secondaryDark
        case .dark: return !reversed ? Colors.shared.secondaryDark : Colors.shared.secondaryLight
        @unknown default:
            return Colors.shared.secondaryDark
        }
    }
    
    ///the getColor function takes in a style and an iOS ColorScheme and returns the corresponding color in the right color scheme. See `UniversalStyle` for more information on which styles are associated with which colors.
    public static func getColor(from style: UniversalStyle, in colorScheme: ColorScheme, reversed: Bool = false) -> Color {
        switch style {
        case .primary: return getBase(from: colorScheme, reversed: reversed)
        case .secondary: return getSecondaryBase(from: colorScheme, reversed: reversed)
        case .accent: return getAccent(from: colorScheme, reversed: reversed)
        default: return Colors.shared.lightAccent
        }
    }
    
    public static let shared = Colors()
    
    ///These are your apps default base colors. These show up in backgrounds of buttons, text, views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.
    @Published public var baseLight = Color( 245, 234, 208 )
    ///These are your apps default base colors. These show up in backgrounds of buttons, text, views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.
    @Published public var baseDark = Color( 0,0,0 )
    
    ///These are your apps default secondary base colors. These show up on top of the base colors but are still intended for backgrounds of views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.
    @Published public var secondaryLight = Color(220, 207, 188)
    ///These are your apps default secondary base colors. These show up on top of the base colors but are still intended for backgrounds of views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.
    @Published public var secondaryDark = Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.9)
    
    ///These are your apps accent colors. These show up on certain styled buttons, when typing in a TextField, or when highlighting content. You can set individual values for light and dark mode.
    @Published public var lightAccent = Color( 0, 87, 66)
    ///These are your apps accent colors. These show up on certain styled buttons, when typing in a TextField, or when highlighting content. You can set individual values for light and dark mode.
    @Published public var darkAccent = Color( 0, 87, 66)
    
    public static var defaultLightAccent = Color( 0, 87, 66)
    public static var defaultDarkAccent = Color( 0, 87, 66)
    
    public static var defaultPrimaryLight = Color(255, 255, 255)
    public static var defaultPrimaryDark = Color(0, 0, 0)
    
    public static var defaultSecondaryLight = Color(220, 207, 188)
    public static var defaultSecondaryDark = Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.9)
    
    public static let yellow = Color(234, 169, 40)
    public static let pink = Color(255, 107, 149)
    public static let purple = Color(106, 38, 153)
    public static let grape = Color(70, 42, 171)
    public static let blue = Color(69, 121, 251)
    public static let red = Color(236, 81, 46)
    
    ///This is a publicly accessible function to change the default accent, base, and secondary colors. Each arg is a convenienceColor, which is an abstracted representation of a SwiftUI Color, but allows you to quickly initialize them with red, green, and blue channels in base 255. If an argument is left as nil, it does not change that color.
    public static func setColors( baseLight:Color?=nil,
                                  secondaryLight:Color?=nil,
                                  baseDark:Color?=nil,
                                  secondaryDark:Color?=nil,
                                  lightAccent:Color?=nil,
                                  darkAccent:Color?=nil,
                                  defaultLightAccent: Color?=nil,
                                  defaultDarkAccent: Color?=nil,
                                  defaultSecondaryLight: Color?=nil,
                                  defaultSecondaryDark: Color?=nil,
                                  matchDefaults: Bool = false) {
        
        Colors.shared.baseLight =      baseLight ?? Colors.shared.baseLight
        Colors.shared.secondaryLight = secondaryLight ?? Colors.shared.secondaryLight
        Colors.shared.baseDark =       baseDark ?? Colors.shared.baseDark
        Colors.shared.secondaryDark =  secondaryDark ?? Colors.shared.secondaryDark
        
        Colors.shared.lightAccent =    lightAccent ?? Colors.shared.lightAccent
        Colors.shared.darkAccent =     darkAccent ?? Colors.shared.darkAccent
        
//        Colors.defaultLightAccent = defaultLightAccent ?? Colors.defaultLightAccent
//        Colors.defaultDarkAccent = defaultDarkAccent ?? Colors.defaultDarkAccent
//        Colors.defaultSecondaryLight = defaultSecondaryLight ?? Colors.defaultSecondaryLight
//        Colors.defaultSecondaryDark = defaultSecondaryDark ?? Colors.defaultSecondaryDark
        
        if matchDefaults {
            Colors.defaultPrimaryLight = Colors.shared.baseLight
            Colors.defaultPrimaryDark = Colors.shared.baseDark
            
            Colors.defaultSecondaryLight = Colors.shared.secondaryLight
            Colors.defaultSecondaryDark = Colors.shared.secondaryDark
            
            Colors.defaultLightAccent = Colors.shared.lightAccent
            Colors.defaultDarkAccent = Colors.shared.darkAccent
        }
        
    }
}

//MARK: ProvidedFonts

///the UniversalFont protocol is the foundation for the font system in UIUniversals. All fonts, both provided by the package and define by users need to conform to this protocol.
public protocol UniversalFont {
    var postScriptName: String { get }
    var fontExtension: String { get }
    static var shared: UniversalFont { get }
}

///This is default font provided by UIUniversals
private struct MadeTommyRegular: UniversalFont {
    static var shared: UniversalFont = MadeTommyRegular()
    
    var postScriptName: String = "MadeTommy"
    var fontExtension: String = "otf"
}

///This is default font provided by UIUniversals
private struct RenoMono: UniversalFont {
    static var shared: UniversalFont = RenoMono()
    
    var postScriptName: String = "RenoMono-Regular"
    var fontExtension: String = "otf"
}

///This is default font provided by UIUniversals
private struct SyneHeavy: UniversalFont {
    static var shared: UniversalFont = SyneHeavy()
    
    var postScriptName: String = "Syne-Bold"
    var fontExtension: String = "ttf"
}


///The FontProvider manages both the registration and access of the default provided fonts. It has a number of important convenience features for invoking fonts throughout the application. FontProvider has no initializers.
public struct FontProvider {
    
///`providedFonts` is the internal list of UniversalFont structures contained in this package
    private static let providedFonts: [UniversalFont] = [
        MadeTommyRegular.shared,
        RenoMono.shared,
        SyneHeavy.shared
    ]

///the ProvidedFont enum on FontProvider specifies the default fonts packaged in UIUniversals. This is a purely convenience feature to access the underlying stored UniversalFonts in the struct.
    public enum ProvidedFont: Int, CaseIterable, Identifiable {
        ///a simple sans serif, light-weight font
        case madeTommyRegular
        ///a designer mono-space font
        case renoMono
        ///a wide format, sans-serif display font
        case syneHeavy
        
        public var id: Int { self.rawValue }
        public func font() -> UniversalFont {
            FontProvider.providedFonts[self.rawValue]
        }
        
        func getUniversalFont() -> String {
            FontProvider.providedFonts[ self.rawValue ].postScriptName
        }
    }
    
    ///registers an individual font
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
    
    ///Any UIUniversal component that takes a custom font accepts a UniversalFont as an arg. For convenient access to the default provided fonts ProvidedFont has a subscript that takes in an instance of the ProvidedFont enum and returns the associated UniversalFont object. It is recommended to access fonts this way.
    public static subscript( font: FontProvider.ProvidedFont ) -> UniversalFont {
        font.font()
    }
    
    public static var registeredDefaultFonts: Bool = false
    
    ///the registerFonts method should be called at the start of the app lifecycle. It goes through all the default fonts provided by FontProvider and registers them in the local app environment. This is not necessary if you are not using the provided fonts. You can still use custom local fonts in your app without calling registerFonts()
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
    public static var UILargeTextSize: CGFloat     = 130
    public static var UITitleTextSize: CGFloat     = 80
    public static var UIMainHeaderTextSize: CGFloat    = 60
    public static var UIHeaderTextSize: CGFloat    = 40
    public static var UISubHeaderTextSize: CGFloat = 30
    public static var UIDefaultTextSize: CGFloat   = 20
    public static var UISmallTextSize: CGFloat     = 15
    
//    timings
//    These are numeric representations of various common time scales. Swift measures all its time in seconds, so adding these values to date objects will produce the expected result. ie. `some date += Constants.DayTime advances the date by a day`
    public static let MinuteTime: Double = 60
    public static let HourTime: Double = 3600
    public static let DayTime: Double = 86400
    public static let WeekTime: Double = 604800
    public static let yearTime: Double = 31557600
    
//    extra
//    These are various additional constants.
    public static var UIDefaultCornerRadius: CGFloat = 40
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
    
    public static func setFontSizes( UILargeTextSize: CGFloat? = nil,
                                     UITitleTextSize: CGFloat? = nil,
                                     UIMainHeaderTextSize: CGFloat? = nil,
                                     UIHeaderTextSize: CGFloat? = nil,
                                     UISubHeaderTextSize: CGFloat? = nil,
                                     UIDefeaultTextSize: CGFloat? = nil,
                                     UISmallTextSize: CGFloat? = nil) {
        
        Constants.UILargeTextSize = UILargeTextSize ?? Constants.UILargeTextSize
        Constants.UITitleTextSize = UITitleTextSize ?? Constants.UITitleTextSize
        Constants.UIMainHeaderTextSize = UIMainHeaderTextSize ?? Constants.UIMainHeaderTextSize
        Constants.UIHeaderTextSize = UIHeaderTextSize ?? Constants.UIHeaderTextSize
        Constants.UISubHeaderTextSize = UISubHeaderTextSize ?? Constants.UISubHeaderTextSize
        Constants.UIDefaultTextSize = UIDefeaultTextSize ?? Constants.UIDefaultTextSize
        Constants.UISmallTextSize = UISmallTextSize ?? Constants.UISmallTextSize
        
    }
    
    
//    if there are any variables that need to be computed at the start, run their setup code here
    @MainActor
    static func setupConstants() {
    }
}
