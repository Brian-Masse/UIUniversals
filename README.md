# **UIUniversals**

UIUniversals is a collection of custom swift & swiftUI views, viewModifiers, and extensions. They are designed to be functional and styled views out of the box, however they boast high customization and flexibility to fit into a variety of apps and projects.

_All components were created and are actively maintained by me, Brian Masse. If you have any question or suggestions, contact me at brianm25it@gmail.com_

This README will act as the documentation for the package. You can search for specific views or functions for an overview of their purpose, their call + parameters, and sample use cases. In addition to this document, descriptions of each component can be found in inline comments in the package itself. Additionally, I created a demonstration project [here](https://github.com/Brian-Masse/UIUniversalsExample) that demonstrates how to contextually use this package.

# **Documentation**

## **viewModifiers**

## **Styled ViewModifiers**

These are a collection of custom viewModifiers, some aesthetic and some utilitarian. All are extensions of the View struct in SwiftUI, and can be invoked with dot syntax.

### **_rectangularBackgrounds_**

rectangularBackground applies a stylized background to any view it is attached to. By default it contains padding, rounding corners, and uses the .primary UniversalStyle.

`private struct RectangularBackground: ViewModifier`

```
init( _ padding: CGFloat? = nil,
    style: UniversalStyle = .primary,
    stroke: Bool = false,
    strokeWidth: CGFloat = 1,
    cornerRadius: CGFloat = Constants.UIDefaultCornerRadius,
    corners: UIRectCorner = .allCorners,
    texture: Bool = false,
    shadow: Bool = false )
```

- `padding` adds the specified padding to the content before applying the rectangular background. Defaults to nil, which uses Apple's defaults .padding() modifier.
- `style` specifies which UniversalStyle to apply to the background. Defaults to .primary
- `stroke` specifies whether or not add a stroke to the background. Defaults to false
- `strokeWidth` specifies the width, in pixels, of the stroke. Defaults to 1.
- `cornerRadius`specifies the cornerRadius of the background. Defaults to the default cornerRadius stored in Constants
- `corners` specifies which corners to apply the cornerRadius to. Specified as a list of corners. Defaults to all corners
- `texture` specifies whether to apply a paper texture to the rectangular background. Defaults to false
- `shadow` specifies whether to apply a shadow to the background. The shadow is a 10pt blur, with a 0.2 opacity black color. Defaults to false

### **_UniversalBackground_**

`private struct UniversalBackground: ViewModifier`

universalBackground applies a specific color to any view it is attached to. It always fills the frame and ignores the safe areas. The content will still respect safe areas. On any given navigation screen, there should only be one view with .universalBackground.

```
init(style: UniversalStyle = .primary,
    padding: CGFloat = 0,
    color: Color? = nil) -> some View
)
```

- `style` specifies which UniversalStyle color to apply to the background. Defaults to .primary.
- `padding` specifies the padding to be applies to the view. Padding is applied to all edges. Defaults to 0. It is best to apply the padding outside of the viewModifier to preserve shadow bleed.
- `color` specifies the color to apply to the background. If a color is provided, it overrides the UniversalStyle arg. Defaults to nil.

### **_UniversalImageBackground_**

`private struct UniversalImageBackground: ViewModifier`

universalImageBackground uses a specified SwiftUI Image for the background. The image is blurred, and a light or dark overlay is applied depending on the system colorScheme. It always fills the frame and ignores safe areas. The content will still respect safe areas. On any given navigation sreen, there should only be one view with .universalImageBackground.

```
init(_ image: Image)
```

- `image` the image to blur on the background

### **_UniversalTextStyle_**

`private struct UniversalTextStyle: ViewModifier`

universalTextStyle dynamically changes the foreground style of the view it is applied to. By default its black when the system is in lightMode and white when the system is in darkMode. Although it is called universalTextStyle, it is intended to be used on views other than SwiftUI Text, to match the default behavior of text.

```
init(reversed: Bool = false)
```

- `reversed` when reversed, foregroundStyle is white on lightMode and black on darkMode. Reversed defaults to false.

### **_UniversalTextField_**

`private struct UniversalTextField: ViewModifier`

universalTextField styles a given textField with the apps accent color, which changes depending on the system ColorScheme, and with a custom font.

```
init(_ font: UniversalFont = FontProvider[.renoMono])
```

- `font` the font to provide to text in the textField. Specified as a UniversalFont, which can be any of the fonts provided by UIUniversals, or a custom font conforming to the UniversalFont protocol. Defaults to RenoMono.

### **_universalForegroundColor_**

`private struct UniversalForegroundStyle: ViewModifier`

universalForegroundStyle sets the foregroundStyle of a view to the correct accent color of the app depending on the system colorScheme. When the colorScheme changes, this viewModifier automatically updates the foregroundStyle with the correct color. It is not publicly accessible.

```
private func universalforegroundStyle() -> some View
```

### **_universalBackgroundColor_**

`private struct UniversalBackgroundColor: ViewModifier`

universalBackgroundStyle sets the background of a view to the correct accent color of the app depending on the system colorScheme. When the colorScheme changes, this viewModifier automatically updates the foregroundStyle with the correct color. It is not publicly accessible.

```
private func universalBackgroundColor() -> some View
```

### **_universalStyledBackground_**

`private struct UniversalStyledBackground: ViewModifier`

universalStyledBackground sets the background of a view to the correct color depending on the specified UniversalStyle and the system ColorScheme. It can also take a custom color to apply to the background. You can also to use these colors on the foreground of the view. When the colorScheme changes, this viewModifier automatically updates the style with the correct color. This modifier should be used instead of universalBackgroundColor or universalForegroundColor

```
init(_ style: UniversalStyle,
    color: Color? = nil,
    onForeground: Bool = false)
```

- `style` this is the UniversalStyle the modifier is using to determine the color of the background or foreground
- `color` this specifies what color to make the background or foreground. If a value is provided, it overrides the style arg. It defaults to nil.
- `onForeground` specifies whether the color should be applied to the foregroundStyle or the background of the view. It defaults to false

## **Utility ViewModifiers**

### **_onBecomingVisible_**

`private struct BecomingVisible: ViewModifier`

onBecomingVisible fires an action every time a view appears on the visible screen. As opposed to .onAppear() which only runs once the first time a view appears on screen, onVisible fires each time a view re-enters the screen.

```
init(perform action: @escaping () -> Void)
```

- `action` is a standard: () -> Void function. It cannot be async, but can contain Task blocks to run async functions.

### **_hideKeyboard_**

`func hideKeyboard()`

the hideKeyboard extension on View minimizes the default iOS keyboard. It can called from a tap gesture, swipe gesture, or any other type of gesture to naturally dismiss the keyboard when a user focuses on another piece of content.

### **_if_**

`if<Content: View>`

The if extension on View creates a conditional modifier, that applies a unique style when a certain condition is met. It automatically refreshes when the condition changes.

```
func `if`<Content: View>( _ condition: Bool, contentBuilder: (Self) -> Content ) -> some View
```

- `condition` the boolean value to trigger whether or not the conditional style is active. It is often best to use in-line condition statements. ie. value == 1

- `contentBuilder` a generic contentBuilder that passes the view the modifier is attached to, into a function to be further modified. All modifiers specified in this contentBuilder are only applied if the condition is met.

## **Fonts, ProvidedFont, and FontProvider**

UIUniversals both provides default fonts as well as a system to define and access custom fonts in its views. The UIUniversal font system fixes the need to implement and initialize custom Fonts in the native SwiftUI .font viewModifier. This makes custom font usage more consistent and easier to implement.

### **_UniversalFont_**

the UniversalFont protocol is the foundation for the font system in UIUniversals. All fonts, both provided by the package and define by users need to conform to this protocol.

```
public protocol UniversalFont {
    var postScriptName: String { get }
    var fontExtension: String { get }
    static var shared: UniversalFont { get }
}
```

### **_FontProvider_**

`public struct FontProvider`

The FontProvider manages both the registration and access of the default provided fonts. It has a number of important convenience features for invoking fonts throughout the application. FontProvider has no initializers.

`public enum ProvidedFont: Int, CaseIterable, Identifiable`

the ProvidedFont enum on FontProvider specifies the default fonts packaged in UIUniversals. This is a purely convenience feature to access the underlying stored UniversalFonts in the struct.

- `case .madeTommyRegular` a simple sans serif, light-weight font
- `case .renoMono` a designer mono-space font
- `case .syneHeavy` a wide format, sans-serif display font

`registerFonts() -> Void`

the registerFonts method should be called at the start of the app lifecycle. It goes through all the default fonts provided by FontProvider and registers them in the local app environment. This is not necessary if you are not using the provided fonts. You can still use custom local fonts in your app without calling registerFonts()

### **_Using & Accessing Fonts_**

Any UIUniversal component that takes a custom font accepts a UniversalFont as an arg. For convenient access to the default provided fonts ProvidedFont has a subscript that takes in an instance of the ProvidedFont enum and returns the associated UniversalFont object. It is recommended to access fonts this way.

`FontProvider[.madeTommyRegular]`

If you copy the provided font files in `sources>fonts` and add them to your apps target + info.plist, you can access them in the default swiftUI Font.custom(_, _) initializer by accessing the postScriptName value of the UniversalFont objects.

Constants provides a `titleFont` and `mainFont` var to quickly set and access a given display and body font. Both are UniversalFonts and can be set to custom defined fonts.

### **_Creating & using custom fonts_**

You can include custom font files in otf or ttf format in your project and use them with the rest of the UIUniversalsPackage.

1. First include the font file in your project scope and add it to the relevant targets. Also include the file name in the `Fonts provided by Application` section of the info.plist.
2. Create a struct that conforms to the UniversalFont protocol. Make sure the postScriptName is accurate, often it is different from the font file name.
3. use the `public static var shared` property on your struct to pass to views that accept UniversalFont args.

## **UniversalStyle**

UniversalStyle is an enum representing the four core styles provided by UIUniversals. Most views / viewModifiers accept a universalStyle arg as a way to specify the style of a component.
`public enum UniversalStyle: String, Identifiable`

- `case .accent` associated with the accent colors of the app
- `case .primary` associated with the base colors of the app
- `case .secondary` associated with the secondary colors of the app
- `case .transparent` not associated with any colors, makes materials .ultraThinMaterial

---

## **Constants**

`public class Constants`

Constants is a container class for universal values. You can extend this class to hold more constant values for use in individual classes. This class has no initializers

### **_Font Sizes_**

These are standard fontSizes that work well with the fonts provided in UIUniversals.
The variable name suggests their intended use. To see examples check out [this repo](https://github.com/Brian-Masse/UIUniversalsExample)

```
    public static let UILargeTextSize: CGFloat     = 130
    public static let UITitleTextSize: CGFloat     = 80
    public static let UIMainHeaderTextSize: CGFloat    = 60
    public static let UIHeaderTextSize: CGFloat    = 40
    public static let UISubHeaderTextSize: CGFloat = 30
    public static let UIDefaultTextSize: CGFloat   = 20
    public static let UISmallTextSize: CGFloat     = 15
```

### **_timings_**

These are numeric representations of various common time scales. Swift measures all its time in seconds, so adding these values to date objects will produce the expected result. ie. `some date += Constants.DayTime advances the date by a day`

```
    public static let MinuteTime: Double = 60
    public static let HourTime: Double = 3600
    public static let DayTime: Double = 86400
    public static let WeekTime: Double = 604800
    public static let yearTime: Double = 31557600
```

### **_extra_**

These are various additional constants.

- _DefaultCornerRadius_ the corner radius is the radius used in `.rectangularBackground` and all UniversalButtons
- _BottomOfPagePadding_ can be used to pad the bottom of a vertical scroll view, giving the bottom pieces of content space to be viewed in the middle of screen.

```
    public static let UIDefaultCornerRadius: CGFloat = 40
    public static let UIBottomOfPagePadding: CGFloat = 130
```

### **_provided fonts_**

for a discussion on fonts in UIUniversals, see the fonts section.

---

## **Colors**

```
@available(iOS 13.0, *)
public class Colors
```

The colors class is a container for default and provided colors. Base Colors and the accent Colors can be modified via the `setColors` method. The class can be extended to house additional default Colors for an application. The Colors class has not initializers.

### **_Accent Color_**

These are your apps accent colors. These show up on certain styled buttons, when typing in a TextField, or when highlighting content. You can set individual values for light and dark mode.

```
public static var lightAccent = makeColor( 0, 87, 66)
public static var darkAccent = makeColor( 0, 87, 66)
```

The getAccent function takes in an iOS ColorScheme and returns the corresponding accent color.

`public static func getAccent(from colorScheme: ColorScheme) -> Color`

### **_Base Color_**

These are your apps default base colors. These show up in backgrounds of buttons, text, and views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.

```
public static var baseLight = makeColor( 245, 234, 208 )
public static var baseDark = makeColor( 0,0,0 )
```

The getBase function takes in an iOS ColorScheme and returns the corresponding base color.

`public static func getBase(from colorScheme: ColorScheme) -> Color`

### **_Secondary Color_**

These are your apps default secondary base colors. These show up on top of the base colors but are still intended for backgrounds of views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.

```
public static var secondaryLight = makeColor(220, 207, 188)
public static var secondaryDark = Color(red: 0.1, green: 0.1, blue: 0.1).opacity(0.9)
```

The getSecondaryBase function takes in an iOS ColorScheme and returns the corresponding secondary color.

`public static func getSecondaryBase(from colorScheme: ColorScheme) -> Color`

### **_Additional Colors_**

These colors are provided by default in UIUniversals and cannot be changed natively. If you want a different value you have to override them in a Colors extension

```
    public static let yellow = makeColor(234, 169, 40)
    public static let pink = makeColor(198, 62, 120)
    public static let purple = makeColor(106, 38, 153)
    public static let grape = makeColor(70, 42, 171)
    public static let blue = makeColor(69, 121, 251)
    public static let red = makeColor(236, 81, 46)
```

### **_makeColor_**

the makeColor function takes a red, green, and blue argument and returns a SwiftUI Color. All values are from 0 to 255. This function is entirely for convenience and to avoid using the built in rgb initializer on Color.

`public static func makeColor( _ r: CGFloat, _ g: CGFloat, _ b: CGFloat ) -> Color`

### **_setColors_**

This is a publicly accessible function to change the default accent, base, and secondary colors. Each arg is a convenienceColor, which is an abstracted representation of a SwiftUI Color, but allows you to quickly initialize them with red, green, and blue channels in base 255. If an argument is left as nil, it does not change that color.

```
    public static func setColors( baseLight:ConvenienceColor?=nil,
                                  secondaryLight:ConvenienceColor?=nil,
                                  baseDark:ConvenienceColor?=nil,
                                  secondaryDark:ConvenienceColor?=nil,
                                  lightAccent:ConvenienceColor?=nil,
                                  darkAccent:ConvenienceColor?=nil )
```

### **_getColor_**

the getColor function takes in a style and an iOS ColorScheme and returns the corresponding color in the right color scheme. See `UniversalStyle` for more information on which styles are associated with which colors.

`public static func getColor(from style: UniversalStyle, in colorScheme: ColorScheme)`

## **Extensions**

## **_Color_**

### _Color.components_

the .components property on a SwiftUI Color object returns the four channels of its color value, red, green, blue, and opacity. Each value is a CGFloat from 0 to 1. They are accessed by name using dot syntax.

```
var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat)
```

### _Color.hex_

the .hex property on a SwiftUI Color object returns a string representing the hex value of the color.

```
var hex: String
```

## **_Date_**

most of the extensions on the Date type are convenience functions to avoid repeating the same calculation when trying to work with a certain property in an app.

### _getHoursFromStartOfDay_

getHoursFromStartOfDay returns a double representing the hours and minutes passed since 12:00AM of a certain date. ie. 5:30AM -> 5.5

```
func getHoursFromStartOfDay() -> Double
```

### _getMinutesFromStartOfHour_

getMinutesFromStartOfHour returns a double representing how many minutes have passed since the start of the current hour. ie. 5:30AM -> 30

```
func getMinutesFromStartOfHour() -> Double
```

### _getYearsSince_

getYearsSince returns a double representing how many years have passed since a given date.

```
func getYearsSince( _ date: Date ) -> Double
```

### _resetToStartOfDay_

resetToStartOfDay sets resets the time components of the date (hour, minutes, seconds) preserving only the calendar date.

```
func resetToStartOfDay() -> Date
```

### _matches_

determines whether the date matches another date to a certain component. Smaller components require all large components to match for this function to return true.

```
func matches(_ secondDate: Date, to component: Calendar.Component) -> Bool
```

### _prioritizeComponent_

erases all subcomponents in the date. For example passing the date 1/28/23, and prioritizing the month produces the date 1/00/23. This function only supports years, months, and days.

```
func prioritizeComponent( _ component: Calendar.Component ) -> Date
```

### _isFirstOfMonth_

checks if the date is the first day of its month

```
func isFirstOfMonth() -> Bool
```

### _isSunday_

checks if the date is a sunday

```
func isSunday() -> Bool
```

### _setMonth_

sets the month value of the date without interrupting any of the other components. If the day is 31 and the month only supports 30 days, the day is automatically set to 00.

```
func setMonth(to month: Int) -> Date
```

### _setDay_

sets the day value of the date without interrupting any of the other components.

```
func setDay(to day: Int) -> Date
```

## **_Extra_**

### _Collection.countAll_

counts the number of occurrences of a given element in a collection.

```
func countAll(where query: ( Self.Element ) -> Bool ) -> Int
```

### _Float.round & Double.rond_

Rounds a Float or Double to the given number of decimal places.

```
func round(to digits: Int) -> Float
func round(to digits: Int) -> Double
```

### _Int.formatIntoPhoneNumber_

takes a given 10 digit Int and creates a string with conventional American phone number formatting. +x (xxx) xxx-xxxx

### _String.removeFirst_

removes the first occurrence of a character. If there are no instances of that char in the string, it returns the original string.

```
func removeFirst( of char: Character ) -> String
```

### _String.removeNonNumbers_

removes all characters that are not numbers.

```
func removeNonNumbers() -> String
```
