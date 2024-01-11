# **UIUniversals**

UIUniversals is a collection of custom swift & swiftUI views, viewModifiers, and extensions. They are designed to be functional and styled views out of the box, however they boast high customization and flexibility to fit into a variety of apps and projects.

_All components were created and are actively maintained by me, Brian Masse. If you have any question or suggestions, contact me at brianm25it@gmail.com_

This README will act as the documentation for the package. You can search for specific view or function for an overview of their purpose, their call + parameters, and sample use cases. In addition to this document, descriptions of each component can be found in inline comments in the package itself. Additionally, I created a demonstration project [here](https://github.com/Brian-Masse/UIUniversalsExample) that demonstrates how to contextually use this package.

# **Documentation**

## Constants & Colors

### **UniversalStyle**

UniversalStyle is an enum representing the four core styles provided by UIUniversals. Most views / viewModifiers accept a universalStyle arg as a way to specify the style of a component.
`public enum UniversalStyle: String, Identifiable`

- `case  .accent` associated with the accent colors of the app
- `case .primary` associated with the base colors of the app
- `case .secondary` associated with the secondary colors of the app
- `case .transparent` not associated with any colors, makes materials .ultraThinMaterial

---

### **Constants**

`public class Constants`

Constants is a container class for universal values. You can extend this class to hold more constant values for use in individual classes. This class has no initializers

**_Font Sizes_**

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

**_timings_**

These are numeric representations of various common time scales. Swift measures all its time in seconds, so adding these values to date objects will produce the expected result. ie. `some date += Constants.DayTime advances the date by a day`

```
    public static let MinuteTime: Double = 60
    public static let HourTime: Double = 3600
    public static let DayTime: Double = 86400
    public static let WeekTime: Double = 604800
    public static let yearTime: Double = 31557600
```

**_extra_**

These are various additional constants.

- _DefaultCornerRadius_ the corner radius is the radius used in `.rectangularBackground` and all UniversalButtons
- _BottomOfPagePadding_ can be used to pad the bottom of a vertical scroll view, giving the bottom pieces of content space to be viewed in the middle of screen.

```
    public static let UIDefaultCornerRadius: CGFloat = 40
    public static let UIBottomOfPagePadding: CGFloat = 130
```

**_provided fonts_**

for a discussion on fonts in UIUniversals, see the fonts section.

---

### **Colors**

```
@available(iOS 13.0, *)
public class Colors
```

The colors class is a container for default and provided colors. Base Colors and the accent Colors can be modified via the `setColors` method. The class can be extended to house additional default Colors for an application.

**_Accent Color_**

These are your apps accent colors. These show up on certain styled buttons, when typing in a TextField, or when highlighting content. You can set individual values for light and dark mode.

```
public static var lightAccent = makeColor( 0, 87, 66)
public static var darkAccent = makeColor( 0, 87, 66)
```

The getAccent function takes in an iOS ColorScheme and returns the corresponding accent color.

`public static func getAccent(from colorScheme: ColorScheme) -> Color`

**_Base Color_**

These are your apps default base colors. These show up in backgrounds of buttons, text, views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.

```
public static var baseLight = makeColor( 245, 234, 208 )
public static var baseDark = makeColor( 0,0,0 )
```

The getBase function takes in an iOS ColorScheme and returns the corresponding base color.
`public static func getBase(from colorScheme: ColorScheme) -> Color`

**_Secondary Color_**

These are your apps default secondary base colors. These show up on top of the base colors but are still intended for backgrounds of views. They should generally be neutral and unintrusive colors. You can and should set individual values for light and dark mode.

The getSecondaryBase function takes in an iOS ColorScheme and returns the corresponding secondary color.

`public static func getSecondaryBase(from colorScheme: ColorScheme) -> Color`

**_Additional Colors_**

These colors are provided by default in UIUniversals and cannot be changed natively. If you want a different value you have to override them in a Colors extension

```
    public static let yellow = makeColor(234, 169, 40)
    public static let pink = makeColor(198, 62, 120)
    public static let purple = makeColor(106, 38, 153)
    public static let grape = makeColor(70, 42, 171)
    public static let blue = makeColor(69, 121, 251)
    public static let red = makeColor(236, 81, 46)
```

**_makeColor_**

the makeColor function takes a red, green, and blue argument and returns a SwiftUI Color. All values are from 0 to 255. This function is entirely for convenience and to avoid using the built in rgb initializer on Color.

`public static func makeColor( _ r: CGFloat, _ g: CGFloat, _ b: CGFloat ) -> Color`

**_setColors_**

This is a publicly accessible function to change the default accent, base, and secondary colors. Each arg is a convenienceColor, which is an abstracted representation of a SwiftUI Color, but allows you to quickly initialize them with red, green, and blue channels in base 255. If an argument is left as nil, it does not change that color.

```
    public static func setColors( baseLight:ConvenienceColor?=nil,
                                  secondaryLight:ConvenienceColor?=nil,
                                  baseDark:ConvenienceColor?=nil,
                                  secondaryDark:ConvenienceColor?=nil,
                                  lightAccent:ConvenienceColor?=nil,
                                  darkAccent:ConvenienceColor?=nil )
```

**_getColor_**

the getColor function takes in a style and an iOS ColorScheme and returns the corresponding color in the right color scheme. See `UniversalStyle` for more information on which styles are associated with which colors.

`public static func getColor(from style: UniversalStyle, in colorScheme: ColorScheme)`
