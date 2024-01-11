# **UIUniversals**

UIUniversals is a collection of custom swift & swiftUI views, viewModifiers, and extensions. They are designed to be functional and styled views out of the box, however they boast high customization and flexibility to fit into a variety of apps and projects.

_All components were created and are actively maintained by me, Brian Masse. If you have any question or suggestions, contact me at brianm25it@gmail.com_

This README will act as the documentation for the package. You can search for specific view or function for an overview of their purpose, their call + parameters, and sample use cases. In addition to this document, descriptions of each component can be found in inline comments in the package itself. Additionally, I created a demonstration project [here](https://github.com/Brian-Masse/UIUniversalsExample) that demonstrates how to contextually use this package.

# **Documentation**

## Constants & Colors

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
