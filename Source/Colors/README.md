# Colors #

#### Generate, convert, and preview color notations ####

Colors is a tool for programmers and designers. It processes any supported color input format, generates a preview of that color, and converts it to other supported formats.

## Usage ##

* Type a **color notation** into Alfred. If Colors supports it, you'll see a preview of that color and conversions to other formats.
* Type a **keyword** (for example, `c`) and choose the "Reveal in color panel" option. This will let you choose a color from the OS X color panel interface.
* Set a **hotkey** to activate the OS X color panel directly.

## Output Syntaxes ##

#### CSS ####

`[...]` denotes an optional parameter

| Format                     | Example                      |
|----------------------------|------------------------------|
| CSS3 Extended Named Colors | `blueviolet`                 |
| Shorthand Hexadecimal      | `#82E`                       |
| RGB[A] Hexadecimal \*      | `#8A2BE2[80]`                |
| RGB[A]                     | `rgba(138, 43, 226[, 0.5])`  |
| RGB[A] Percentage          | `rgb(54%, 17%, 89%[, 0.5])`  |
| HSL[A]                     | `hsla(271, 76%, 53%[, 0.5])` |

<small>\* CSS3 does not support 32-bit (RGBA) Hexadecimal notation</small>

#### Cocoa ####

| Format                   | Example                                                                               |
|--------------------------|---------------------------------------------------------------------------------------|
| NSColor (Calibrated RGB) | `[NSColor colorWithCalibratedRed: 0.541 green: 0.169 blue: 0.886 alpha: 1]`           |
| NSColor (Device RGB)     | `[NSColor colorWithDeviceRed: 0.541 green: 0.169 blue: 0.886 alpha: 1]`               |
| NSColor (Calibrated HSB) | `[NSColor colorWithCalibratedHue: 0.753 saturation: 0.81 brightness: 0.886 alpha: 1]` |
| NSColor (Device HSB)     | `[NSColor colorWithDeviceHue: 0.753 saturation: 0.81 brightness: 0.886 alpha: 1]`     |
| UIColor (RGB)            | `[UIColor colorWithRed: 0.541 green: 0.169 blue: 0.886 alpha: 1]`                     |
| UIColor (HSB)            | `[UIColor colorWithHue: 0.753 saturation: 0.81 brightness: 0.886 alpha: 1]`           |

## Input Syntaxes ##

Input syntaxes are *very* permissive. The parsing engine used by Colors recognizes all output syntaxes and several shorthand formats. Whitespace is generally ignored, unless used as a separator.

#### CSS ####

`[...]` denotes an optional parameter

| Format            | Shorthand             |
|-------------------|-----------------------|
| RGB[A]            | `rgb138 43 226[ .5]`  |
| RGB[A] Percentage | `rgb54% 17% 89%[ .5]` |
| HSL[A]            | `hsl271 76% 53%[ .5]` |

#### Cocoa ####

| Format                   | Shorthand             |
|--------------------------|-----------------------|
| NSColor (Calibrated RGB) | `ns.541 .169 .886 1`  |
| NSColor (Device RGB)     | `nsd.541 .169 .886 1` |
| NSColor (Calibrated HSB) | `nsh.753 .81 .886 1`  |
| NSColor (Device HSB)     | `nsdh.753 .81 .886 1` |
| UIColor (RGB)            | `ui.541 .169 .886 1`  |
| UIColor (HSB)            | `uih.753 .81 .886 1`  |


## Screenshots ##

![Hexadecimal input](Screenshots/Colors-Hexadecimal.png)
![UIColor input](Screenshots/Colors-UIColor.png)
![NSColor shorthand input](Screenshots/Colors-NSColor.png)
