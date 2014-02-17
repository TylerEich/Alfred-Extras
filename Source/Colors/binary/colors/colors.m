//
//  colors.m
//  Color-Picker
//
//  Created by Tyler on 10/3/13.
//  Copyright (c) 2013 Tyler. All rights reserved.
//

#import "colors.h"

@implementation NSString (Colors)
- (NSString*) stringByPreservingCharactersInString: (NSString*)preservedCharacters {
    NSMutableArray *stringArray = (NSMutableArray*)[self componentsSeparatedByCharactersInSet:
                                                    [[NSCharacterSet characterSetWithCharactersInString:preservedCharacters] invertedSet]];
    if ([stringArray count] == 1) stringArray = [NSMutableArray arrayWithObject:self];
    if ([stringArray indexOfObject:@""] != NSNotFound) [stringArray removeObject:@""];
    return [[stringArray componentsJoinedByString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSMutableArray*) componentsSeparatedByCharactersInString: (NSString*)separatorCharacters {
    NSMutableArray *stringArray = (NSMutableArray*)[self componentsSeparatedByCharactersInSet:
                                                    [NSCharacterSet characterSetWithCharactersInString:separatorCharacters]];

    if ([stringArray count] == 1) stringArray = [NSMutableArray arrayWithObject:self];
    if ([stringArray indexOfObject:@""] != NSNotFound) [stringArray removeObject:@""];
    return (NSMutableArray*)stringArray;
}
@end

@implementation NSColor (Colors)
- (NSString*) hexadecimal {
    float r, g, b, a;
    r = [self redComponent];
    g = [self greenComponent];
    b = [self blueComponent];
    a = [self alphaComponent];

    return [NSString stringWithFormat:@"%.8X",
            (unsigned int)
            ((256 * 256 * 256 * round(r * 255.0)) +
             (256 * 256 * round(g * 255.0)) +
             (256 * round(b * 255.0)) +
             (round(a * 255.0)))];
}

- (NSColor*) colorWithOffsetHue: (float)hueOffset
                     saturation: (float)saturationOffset
                     brightness: (float)brightnessOffset
                          alpha: (float)alphaOffset {
    float h, s, b, a;
    h = fmodf([self hueComponent] + hueOffset, 1);

    s = [self saturationComponent] + saturationOffset;
    if (s > 1) s = 1.0;
    else if (s < 0) s = 0.0;

    b = [self brightnessComponent];
    if (b > 1) b = 1.0;
    else if (b < 0) b = 0.0;

    a = [self alphaComponent];
    if (a > 1) a = 1.0;
    else if (a < 0) a = 0.0;

    return [NSColor colorWithCalibratedHue:h
                                saturation:s
                                brightness:b
                                     alpha:a];
}
- (NSColor*) complement {
    return [self colorWithOffsetHue:0.5
                         saturation:0
                         brightness:0
                              alpha:0];
}
- (NSColor*) triadByDecimal: (float)decimal {
    return [self colorWithOffsetHue:0.5 + decimal
                         saturation:0
                         brightness:0
                              alpha:0];
}
- (NSColor*) tetradByDecimal: (float)decimal
           fromComplementary: (bool)fromComplementary {
    decimal += fromComplementary ? 0.5 : 0;

    return [self colorWithOffsetHue:0.5 + decimal
                         saturation:0
                         brightness:0
                              alpha:0];
}
- (NSColor*) analogicByDecimal: (float)decimal {
    return [self colorWithOffsetHue:decimal
                         saturation:0
                         brightness:0
                              alpha:0];
}
- (NSColor*) brightenByDecimal: (float)decimal {
    return [self colorWithOffsetHue:0
                         saturation:0
                         brightness:decimal
                              alpha:0];
}
- (NSColor*) saturateByDecimal: (float)decimal {
    return [self colorWithOffsetHue:0
                         saturation:decimal
                         brightness:0
                              alpha:0];
}

+ (NSArray*) cssNamedColors {
    return @[@{@"value":@"f0f8ffff",@"name":@"aliceblue"},@{@"value":@"faebd7ff",@"name":@"antiquewhite"},@{@"value":@"00ffffff",@"name":@"aqua"},@{@"value":@"7fffd4ff",@"name":@"aquamarine"},@{@"value":@"f0ffffff",@"name":@"azure"},@{@"value":@"f5f5dcff",@"name":@"beige"},@{@"value":@"ffe4c4ff",@"name":@"bisque"},@{@"value":@"000000ff",@"name":@"black"},@{@"value":@"ffebcdff",@"name":@"blanchedalmond"},@{@"value":@"0000ffff",@"name":@"blue"},@{@"value":@"8a2be2ff",@"name":@"blueviolet"},@{@"value":@"a52a2aff",@"name":@"brown"},@{@"value":@"deb887ff",@"name":@"burlywood"},@{@"value":@"ea7e5dff",@"name":@"burntsienna"},@{@"value":@"5f9ea0ff",@"name":@"cadetblue"},@{@"value":@"7fff00ff",@"name":@"chartreuse"},@{@"value":@"d2691eff",@"name":@"chocolate"},@{@"value":@"ff7f50ff",@"name":@"coral"},@{@"value":@"6495edff",@"name":@"cornflowerblue"},@{@"value":@"fff8dcff",@"name":@"cornsilk"},@{@"value":@"dc143cff",@"name":@"crimson"},@{@"value":@"00ffffff",@"name":@"cyan"},@{@"value":@"00008bff",@"name":@"darkblue"},@{@"value":@"008b8bff",@"name":@"darkcyan"},@{@"value":@"b8860bff",@"name":@"darkgoldenrod"},@{@"value":@"a9a9a9ff",@"name":@"darkgray"},@{@"value":@"006400ff",@"name":@"darkgreen"},@{@"value":@"a9a9a9ff",@"name":@"darkgrey"},@{@"value":@"bdb76bff",@"name":@"darkkhaki"},@{@"value":@"8b008bff",@"name":@"darkmagenta"},@{@"value":@"556b2fff",@"name":@"darkolivegreen"},@{@"value":@"ff8c00ff",@"name":@"darkorange"},@{@"value":@"9932ccff",@"name":@"darkorchid"},@{@"value":@"8b0000ff",@"name":@"darkred"},@{@"value":@"e9967aff",@"name":@"darksalmon"},@{@"value":@"8fbc8fff",@"name":@"darkseagreen"},@{@"value":@"483d8bff",@"name":@"darkslateblue"},@{@"value":@"2f4f4fff",@"name":@"darkslategray"},@{@"value":@"2f4f4fff",@"name":@"darkslategrey"},@{@"value":@"00ced1ff",@"name":@"darkturquoise"},@{@"value":@"9400d3ff",@"name":@"darkviolet"},@{@"value":@"ff1493ff",@"name":@"deeppink"},@{@"value":@"00bfffff",@"name":@"deepskyblue"},@{@"value":@"696969ff",@"name":@"dimgray"},@{@"value":@"696969ff",@"name":@"dimgrey"},@{@"value":@"1e90ffff",@"name":@"dodgerblue"},@{@"value":@"b22222ff",@"name":@"firebrick"},@{@"value":@"fffaf0ff",@"name":@"floralwhite"},@{@"value":@"228b22ff",@"name":@"forestgreen"},@{@"value":@"ff00ffff",@"name":@"fuchsia"},@{@"value":@"dcdcdcff",@"name":@"gainsboro"},@{@"value":@"f8f8ffff",@"name":@"ghostwhite"},@{@"value":@"ffd700ff",@"name":@"gold"},@{@"value":@"daa520ff",@"name":@"goldenrod"},@{@"value":@"808080ff",@"name":@"gray"},@{@"value":@"008000ff",@"name":@"green"},@{@"value":@"adff2fff",@"name":@"greenyellow"},@{@"value":@"808080ff",@"name":@"grey"},@{@"value":@"f0fff0ff",@"name":@"honeydew"},@{@"value":@"ff69b4ff",@"name":@"hotpink"},@{@"value":@"cd5c5cff",@"name":@"indianred"},@{@"value":@"4b0082ff",@"name":@"indigo"},@{@"value":@"fffff0ff",@"name":@"ivory"},@{@"value":@"f0e68cff",@"name":@"khaki"},@{@"value":@"e6e6faff",@"name":@"lavender"},@{@"value":@"fff0f5ff",@"name":@"lavenderblush"},@{@"value":@"7cfc00ff",@"name":@"lawngreen"},@{@"value":@"fffacdff",@"name":@"lemonchiffon"},@{@"value":@"add8e6ff",@"name":@"lightblue"},@{@"value":@"f08080ff",@"name":@"lightcoral"},@{@"value":@"e0ffffff",@"name":@"lightcyan"},@{@"value":@"fafad2ff",@"name":@"lightgoldenrodyellow"},@{@"value":@"d3d3d3ff",@"name":@"lightgray"},@{@"value":@"90ee90ff",@"name":@"lightgreen"},@{@"value":@"d3d3d3ff",@"name":@"lightgrey"},@{@"value":@"ffb6c1ff",@"name":@"lightpink"},@{@"value":@"ffa07aff",@"name":@"lightsalmon"},@{@"value":@"20b2aaff",@"name":@"lightseagreen"},@{@"value":@"87cefaff",@"name":@"lightskyblue"},@{@"value":@"778899ff",@"name":@"lightslategray"},@{@"value":@"778899ff",@"name":@"lightslategrey"},@{@"value":@"b0c4deff",@"name":@"lightsteelblue"},@{@"value":@"ffffe0ff",@"name":@"lightyellow"},@{@"value":@"00ff00ff",@"name":@"lime"},@{@"value":@"32cd32ff",@"name":@"limegreen"},@{@"value":@"faf0e6ff",@"name":@"linen"},@{@"value":@"ff00ffff",@"name":@"magenta"},@{@"value":@"800000ff",@"name":@"maroon"},@{@"value":@"66cdaaff",@"name":@"mediumaquamarine"},@{@"value":@"0000cdff",@"name":@"mediumblue"},@{@"value":@"ba55d3ff",@"name":@"mediumorchid"},@{@"value":@"9370dbff",@"name":@"mediumpurple"},@{@"value":@"3cb371ff",@"name":@"mediumseagreen"},@{@"value":@"7b68eeff",@"name":@"mediumslateblue"},@{@"value":@"00fa9aff",@"name":@"mediumspringgreen"},@{@"value":@"48d1ccff",@"name":@"mediumturquoise"},@{@"value":@"c71585ff",@"name":@"mediumvioletred"},@{@"value":@"191970ff",@"name":@"midnightblue"},@{@"value":@"f5fffaff",@"name":@"mintcream"},@{@"value":@"ffe4e1ff",@"name":@"mistyrose"},@{@"value":@"ffe4b5ff",@"name":@"moccasin"},@{@"value":@"ffdeadff",@"name":@"navajowhite"},@{@"value":@"000080ff",@"name":@"navy"},@{@"value":@"fdf5e6ff",@"name":@"oldlace"},@{@"value":@"808000ff",@"name":@"olive"},@{@"value":@"6b8e23ff",@"name":@"olivedrab"},@{@"value":@"ffa500ff",@"name":@"orange"},@{@"value":@"ff4500ff",@"name":@"orangered"},@{@"value":@"da70d6ff",@"name":@"orchid"},@{@"value":@"eee8aaff",@"name":@"palegoldenrod"},@{@"value":@"98fb98ff",@"name":@"palegreen"},@{@"value":@"afeeeeff",@"name":@"paleturquoise"},@{@"value":@"db7093ff",@"name":@"palevioletred"},@{@"value":@"ffefd5ff",@"name":@"papayawhip"},@{@"value":@"ffdab9ff",@"name":@"peachpuff"},@{@"value":@"cd853fff",@"name":@"peru"},@{@"value":@"ffc0cbff",@"name":@"pink"},@{@"value":@"dda0ddff",@"name":@"plum"},@{@"value":@"b0e0e6ff",@"name":@"powderblue"},@{@"value":@"800080ff",@"name":@"purple"},@{@"value":@"ff0000ff",@"name":@"red"},@{@"value":@"bc8f8fff",@"name":@"rosybrown"},@{@"value":@"4169e1ff",@"name":@"royalblue"},@{@"value":@"8b4513ff",@"name":@"saddlebrown"},@{@"value":@"fa8072ff",@"name":@"salmon"},@{@"value":@"f4a460ff",@"name":@"sandybrown"},@{@"value":@"2e8b57ff",@"name":@"seagreen"},@{@"value":@"fff5eeff",@"name":@"seashell"},@{@"value":@"a0522dff",@"name":@"sienna"},@{@"value":@"c0c0c0ff",@"name":@"silver"},@{@"value":@"87ceebff",@"name":@"skyblue"},@{@"value":@"6a5acdff",@"name":@"slateblue"},@{@"value":@"708090ff",@"name":@"slategray"},@{@"value":@"708090ff",@"name":@"slategrey"},@{@"value":@"fffafaff",@"name":@"snow"},@{@"value":@"00ff7fff",@"name":@"springgreen"},@{@"value":@"4682b4ff",@"name":@"steelblue"},@{@"value":@"d2b48cff",@"name":@"tan"},@{@"value":@"008080ff",@"name":@"teal"},@{@"value":@"d8bfd8ff",@"name":@"thistle"},@{@"value":@"ff6347ff",@"name":@"tomato"},@{@"value":@"00000000",@"name":@"transparent"},@{@"value":@"40e0d0ff",@"name":@"turquoise"},@{@"value":@"ee82eeff",@"name":@"violet"},@{@"value":@"f5deb3ff",@"name":@"wheat"},@{@"value":@"ffffffff",@"name":@"white"},@{@"value":@"f5f5f5ff",@"name":@"whitesmoke"},@{@"value":@"ffff00ff",@"name":@"yellow"},@{@"value":@"9acd32ff",@"name":@"yellowgreen"}];
}
+ (NSArray*) objCNamedColors {
    return @[@{@"value":[NSColor blackColor],@"name":@"blackColor"},@{@"value":[NSColor blueColor],@"name":@"blueColor"},@{@"value":[NSColor brownColor],@"name":@"brownColor"},@{@"value":[NSColor clearColor],@"name":@"clearColor"},@{@"value":[NSColor cyanColor],@"name":@"cyanColor"},@{@"value":[NSColor darkGrayColor],@"name":@"darkGrayColor"},@{@"value":[NSColor grayColor],@"name":@"grayColor"},@{@"value":[NSColor greenColor],@"name":@"greenColor"},@{@"value":[NSColor lightGrayColor],@"name":@"lightGrayColor"},@{@"value":[NSColor magentaColor],@"name":@"magentaColor"},@{@"value":[NSColor orangeColor],@"name":@"orangeColor"},@{@"value":[NSColor purpleColor],@"name":@"purpleColor"},@{@"value":[NSColor redColor],@"name":@"redColor"},@{@"value":[NSColor whiteColor],@"name":@"whiteColor"},@{@"value":[NSColor yellowColor],@"name":@"yellowColor"}];
}
+ (NSArray*) nsNamedColors {
    return @[@{@"value":[NSColor alternateSelectedControlColor],@"name":@"alternateSelectedControlColor"},@{@"value":[NSColor alternateSelectedControlTextColor],@"name":@"alternateSelectedControlTextColor"},@{@"value":[NSColor controlBackgroundColor],@"name":@"controlBackgroundColor"},@{@"value":[NSColor controlColor],@"name":@"controlColor"},@{@"value":[NSColor controlAlternatingRowBackgroundColors],@"name":@"controlAlternatingRowBackgroundColors"},@{@"value":[NSColor controlHighlightColor],@"name":@"controlHighlightColor"},@{@"value":[NSColor controlLightHighlightColor],@"name":@"controlLightHighlightColor"},@{@"value":[NSColor controlShadowColor],@"name":@"controlShadowColor"},@{@"value":[NSColor controlDarkShadowColor],@"name":@"controlDarkShadowColor"},@{@"value":[NSColor controlTextColor],@"name":@"controlTextColor"},@{@"value":[NSColor disabledControlTextColor],@"name":@"disabledControlTextColor"},@{@"value":[NSColor gridColor],@"name":@"gridColor"},@{@"value":[NSColor headerColor],@"name":@"headerColor"},@{@"value":[NSColor headerTextColor],@"name":@"headerTextColor"},@{@"value":[NSColor highlightColor],@"name":@"highlightColor"},@{@"value":[NSColor keyboardFocusIndicatorColor],@"name":@"keyboardFocusIndicatorColor"},@{@"value":[NSColor knobColor],@"name":@"knobColor"},@{@"value":[NSColor scrollBarColor],@"name":@"scrollBarColor"},@{@"value":[NSColor secondarySelectedControlColor],@"name":@"secondarySelectedControlColor"},@{@"value":[NSColor selectedControlColor],@"name":@"selectedControlColor"},@{@"value":[NSColor selectedControlTextColor],@"name":@"selectedControlTextColor"},@{@"value":[NSColor selectedMenuItemColor],@"name":@"selectedMenuItemColor"},@{@"value":[NSColor selectedMenuItemTextColor],@"name":@"selectedMenuItemTextColor"},@{@"value":[NSColor selectedTextBackgroundColor],@"name":@"selectedTextBackgroundColor"},@{@"value":[NSColor selectedTextColor],@"name":@"selectedTextColor"},@{@"value":[NSColor selectedKnobColor],@"name":@"selectedKnobColor"},@{@"value":[NSColor shadowColor],@"name":@"shadowColor"},@{@"value":[NSColor textBackgroundColor],@"name":@"textBackgroundColor"},@{@"value":[NSColor textColor],@"name":@"textColor"},@{@"value":[NSColor windowBackgroundColor],@"name":@"windowBackgroundColor"},@{@"value":[NSColor windowFrameColor],@"name":@"windowFrameColor"},@{@"value":[NSColor windowFrameTextColor],@"name":@"windowFrameTextColor"},@{@"value":[NSColor underPageBackgroundColor],@"name":@"underPageBackgroundColor"}];
}
@end

@implementation NSImage (Colors)
- (void) saveAtPath: (NSString*)path {
    NSData *data = [self TIFFRepresentation];
    NSBitmapImageRep *representation = [NSBitmapImageRep imageRepWithData:data];
    NSDictionary *properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    data = [representation representationUsingType:NSPNGFileType properties:properties];
    [data writeToFile:path atomically:NO];
}
@end

@implementation Colors
- (void) savePreviewToPath: (NSString*)path {
    NSImage *preview = [[NSImage alloc] initWithContentsOfFile:@"contrast.png"];
    [preview lockFocus];
    NSColor *imageColor = [NSColor colorWithSRGBRed:[color redComponent]
                                                green:[color greenComponent]
                                                 blue:[color blueComponent]
                                                alpha:[color alphaComponent]];
    [imageColor setFill];
    // Not sure why 6 and 84 do the trick...
    NSRectFillUsingOperation(NSMakeRect(6, 6, 84, 84), NSCompositeSourceOver);
    [preview unlockFocus];
    [preview saveAtPath:path];
}
- (void) feedback {
    AWWorkflow *workflow = [AWWorkflow workflow];
    NSArray *output = [self output];
    NSString *uidBase = [NSString stringWithFormat:@"%@ %@ to ", [workflow bundleID], [self preferredFormatForMostRecentKey]];
    NSMutableArray *itemArray = [NSMutableArray new];
    NSString *icon = [NSString stringWithFormat:@"%@/%@.png", [workflow cache], [color hexadecimal]];
    [self savePreviewToPath:icon];

    NSDictionary *thisOutput;
    NSString *uid, *description, *argument, *autocomplete;
    AWFeedbackItem *item;

    for (int i = 0; i < [output count]; i++)
     {
        thisOutput = [output objectAtIndex:i];
        uid = [uidBase stringByAppendingString:[thisOutput objectForKey:@"id"]];
        description = [thisOutput objectForKey:@"description"];
        argument = [thisOutput objectForKey:@"argument"];
        if ([[thisOutput objectForKey:@"id"] isEqual:[self preferredFormatForMostRecentKey]])
         {
            autocomplete = [thisOutput objectForKey:@"autocomplete"];
            item = [AWFeedbackItem itemWithObjectsAndKeys:
                    uid, @"uid",
                    argument, @"arg",
                    argument, @"title",
                    description, @"subtitle",
                    icon, @"icon",
                    @YES, @"valid",
                    autocomplete, @"autocomplete",
                    nil];
         }
        else
         {
            item = [AWFeedbackItem itemWithObjectsAndKeys:
                    uid, @"uid",
                    argument, @"arg",
                    argument, @"title",
                    description, @"subtitle",
                    icon, @"icon",
                    @YES, @"valid",
                    nil];
         }
        [itemArray addObject:item];
     }

    [workflow flush:YES feedbackArray:(NSArray*)itemArray];
}
- (void) fallbackToColorPanelResult: (NSString*)title {
    AWWorkflow *workflow = [AWWorkflow workflow];
    NSString *uid = [[workflow bundleID] stringByAppendingString:@" color-pick"];

    AWFeedbackItem *item = [AWFeedbackItem itemWithObjectsAndKeys:
                            uid, @"uid",
                            @"", @"arg",
                            @"pick-color.png", @"icon",
                            title, @"title",
                            @"Action this item to open the OS X color panel", @"subtitle",
                            @YES, @"valid",
                            nil];

    [workflow flush:YES feedbackItems:item, nil];
}
- (void) fallbackToColorPanelResult {
    [self fallbackToColorPanelResult:@"OS X Color Panel"];
}
- (void) openColorPanel {
    NSString *input = @"";
    if ([self color]) input = [NSString stringWithFormat:@"%f %f %f %f",
                               [color redComponent],
                               [color greenComponent],
                               [color blueComponent],
                               [color alphaComponent]];

    NSTask *colorPanel = [[NSTask alloc] init];
    [colorPanel setLaunchPath:@"Colors.app/Contents/MacOS/Colors"];
    [colorPanel setArguments:@[input]];

    NSPipe *pipe = [NSPipe pipe];
    [colorPanel setStandardOutput:pipe];

    [colorPanel launch];
    [colorPanel waitUntilExit];

    NSFileHandle *read = [pipe fileHandleForReading];
    NSData *data = [read readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if ([output isEqual:@""]) return;
    NSArray *array = [output componentsSeparatedByString:@" "];

    float r, g, b, a;
    r = [[array objectAtIndex:0] floatValue];
    g = [[array objectAtIndex:1] floatValue];
    b = [[array objectAtIndex:2] floatValue];
    a = [[array objectAtIndex:3] floatValue];
    [self setColor:[NSColor colorWithCalibratedRed:r green:g blue:b alpha:a]];

    [self sendToAlfred];
}
- (NSArray*) output {
    if (![self color]) return @[];
    float r, g, b, h, s, ss, l, v, a; // 'ss' is HSL saturation
    NSArray *css, *ns, *ui;
    NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
    r = [color redComponent];
    g = [color greenComponent];
    b = [color blueComponent];
    h = [color hueComponent];
    s = [color saturationComponent];
    v = [color brightnessComponent];
    a = [color alphaComponent];

    // HSL conversions
    l = (2.0 - s) * v;
    ss = s * v;
    ss /= (l <= 1) ? l : 2.0 - l;
    if (isnan(ss)) ss = 0.0;

    l /= 2.0;

    NSString *hexadecimal = [color hexadecimal];
    bool ignoreAlpha = (toggleAlpha == (a != 1.0));

    ns = @[];
    ui = @[];

    if (s == 0)
     {
        ns = [ns arrayByAddingObjectsFromArray:@[@{
                                                     @"id":@"ns-calibrated-white",
                                                     @"description":@"NSColor • Calibrated White",
                                                     @"argument":[NSString stringWithFormat:@"[NSColor colorWithCalibratedWhite: %.3g alpha: %.3g]", v, ignoreAlpha ? 1.0 : a],
                                                     @"autocomplete":[NSString stringWithFormat:@"Color colorWithCalibratedWhite: %.3g alpha: %.3g]", v, ignoreAlpha ? 1.0 : a]
                                                     },
                                                 @{
                                                     @"id":@"ns-device-white",
                                                     @"description":@"NSColor • Device White",
                                                     @"argument":[NSString stringWithFormat:@"[NSColor colorWithDeviceWhite: %.3g alpha: %.3g]", v, ignoreAlpha ? 1.0 : a],
                                                     @"autocomplete":[NSString stringWithFormat:@"Color colorWithDeviceWhite: %.3g alpha: %.3g]", v, ignoreAlpha ? 1.0 : a]
                                                     }]];

        ui = [ui arrayByAddingObjectsFromArray:@[@{
                                                     @"id":@"ui-white",
                                                     @"description":@"UIColor • White",
                                                     @"argument":[NSString stringWithFormat:@"[UIColor colorWithWhite: %.3g alpha: %.3g]", v, ignoreAlpha ? 1.0 : a],
                                                     @"autocomplete":[NSString stringWithFormat:@"Color colorWithWhite: %.3g alpha: %.3g]", v, ignoreAlpha ? 1.0 : a]
                                                     }]];
     }
    ns = [ns arrayByAddingObjectsFromArray:@[@{
                                                 @"id":@"ns-calibrated-rgb",
                                                 @"description":@"NSColor • Calibrated RGB",
                                                 @"argument":[NSString stringWithFormat:@"[NSColor colorWithCalibratedRed: %.3g green: %.3g blue: %.3g alpha: %.3g]", r, g, b, ignoreAlpha ? 1.0 : a],
                                                 @"autocomplete":[NSString stringWithFormat:@"Color colorWithCalibratedRed: %.3g green: %.3g blue: %.3g alpha: %.3g]", r, g, b, ignoreAlpha ? 1.0 : a]
                                                 },
                                             @{
                                                 @"id":@"ns-calibrated-hsb",
                                                 @"description":@"NSColor • Calibrated HSB",
                                                 @"argument":[NSString stringWithFormat:@"[NSColor colorWithCalibratedHue: %.3g saturation: %.3g brightness: %.3g alpha: %.3g]", h, s, v, ignoreAlpha ? 1.0 : a],
                                                 @"autocomplete":[NSString stringWithFormat:@"Color colorWithCalibratedHue: %.3g saturation: %.3g brightness: %.3g alpha: %.3g]", h, s, v, ignoreAlpha ? 1.0 : a]
                                                 },
                                             @{
                                                 @"id":@"ns-device-rgb",
                                                 @"description":@"NSColor • Device RGB",
                                                 @"argument":[NSString stringWithFormat:@"[NSColor colorWithDeviceRed: %.3g green: %.3g blue: %.3g alpha: %.3g]", r, g, b, ignoreAlpha ? 1.0 : a],
                                                 @"autocomplete":[NSString stringWithFormat:@"Color colorWithDeviceRed: %.3g green: %.3g blue: %.3g alpha: %.3g]", r, g, b, ignoreAlpha ? 1.0 : a]
                                                 },
                                             @{
                                                 @"id":@"ns-device-hsb",
                                                 @"description":@"NSColor • Device HSB",
                                                 @"argument":[NSString stringWithFormat:@"[NSColor colorWithDeviceHue: %.3g saturation: %.3g brightness: %.3g alpha: %.3g]", h, s, v, ignoreAlpha ? 1.0 : a],
                                                 @"autocomplete":[NSString stringWithFormat:@"Color colorWithDeviceHue: %.3g saturation: %.3g brightness: %.3g alpha: %.3g]", h, s, v, ignoreAlpha ? 1.0 : a]
                                                 }]];

    ui = [ui arrayByAddingObjectsFromArray:@[@{
                                                 @"id":@"ui-rgb",
                                                 @"description":@"UIColor • RGB",
                                                 @"argument":[NSString stringWithFormat:@"[UIColor colorWithRed: %.3g green: %.3g blue: %.3g alpha: %.3g]", r, g, b, ignoreAlpha ? 1.0 : a],
                                                 @"autocomplete":[NSString stringWithFormat:@"Color colorWithRed: %.3g green: %.3g blue: %.3g alpha: %.3g]", r, g, b, ignoreAlpha ? 1.0 : a]
                                                 },
                                             @{
                                                 @"id":@"ui-hsb",
                                                 @"description":@"UIColor • HSB",
                                                 @"argument":[NSString stringWithFormat:@"[UIColor colorWithHue: %.3g saturation: %.3g brightness: %.3g alpha: %.3g]", h, s, v, ignoreAlpha ? 1.0 : a],
                                                 @"autocomplete":[NSString stringWithFormat:@"Color colorWithHue: %.3g saturation: %.3g brightness: %.3g alpha: %.3g]", h, s, v, ignoreAlpha ? 1.0 : a]
                                                 }]];
    if (ignoreAlpha) // Values with full opacity
     {

        css = @[@{
                    @"id":@"css-rgb",
                    @"description":@"CSS • RGB",
                    @"argument":[NSString stringWithFormat:@"rgb(%.f, %.f, %.f)", r * 255.0, g * 255.0, b * 255.0],
                    @"autocomplete":[NSString stringWithFormat:@"(%.f, %.f, %.f)", r * 255.0, g * 255.0, b * 255.0]
                    },
                @{
                    @"id":@"css-rgb%",
                    @"description":@"CSS • RGB Percent",
                    @"argument":[NSString stringWithFormat:@"rgb(%.f%%, %.f%%, %.f%%)", r * 100.0, g * 100.0, b * 100.0],
                    @"autocomplete":[NSString stringWithFormat:@"(%.f%%, %.f%%, %.f%%)", r * 100.0, g * 100.0, b * 100.0]
                    },
                @{
                    @"id":@"css-hex",
                    @"description":@"CSS • Hexadecimal",
                    @"argument":[NSString stringWithFormat:@"#%@", [hexadecimal substringToIndex:6]],
                    @"autocomplete":[NSString stringWithFormat:@"%@", [hexadecimal substringToIndex:6]]
                    },
                @{
                    @"id":@"css-hsl",
                    @"description":@"CSS • HSL",
                    @"argument":[NSString stringWithFormat:@"hsl(%.f, %.f%%, %.f%%)", h * 360.0, ss * 100.0, l * 100.0],
                    @"autocomplete":[NSString stringWithFormat:@"(%.f, %.f%%, %.f%%)", h * 360.0, ss * 100.0, l * 100.0]
                    }
                ];
     }
    else // Values with alpha channel
     {
        css = @[@{
                    @"id":@"css-rgb",
                    @"description":@"CSS • RGBA",
                    @"argument":[NSString stringWithFormat:@"rgba(%.f, %.f, %.f, %.2g)", r * 255.0, g * 255.0, b * 255.0, a],
                    @"autocomplete":[NSString stringWithFormat:@"a(%.f, %.f, %.f, %.2g)", r * 255.0, g * 255.0, b * 255.0, a]
                    },
                @{
                    @"id":@"css-rgb%",
                    @"description":@"CSS • RGBA Percent",
                    @"argument":[NSString stringWithFormat:@"rgba(%.f%%, %.f%%, %.f%%, %.f)", r * 100.0, g * 100.0, b * 100.0, a],
                    @"autocomplete":[NSString stringWithFormat:@"a(%.f%%, %.f%%, %.f%%, %.f)", r * 100.0, g * 100.0, b * 100.0, a]
                    },
                @{
                    @"id":@"css-hex",
                    @"description":@"32-Bit Hexadecimal",
                    @"argument":[NSString stringWithFormat:@"#%@", hexadecimal],
                    @"autocomplete":[NSString stringWithFormat:@"%@", hexadecimal]
                    },
                @{
                    @"id":@"css-hsl",
                    @"description":@"CSS • HSLA",
                    @"argument":[NSString stringWithFormat:@"hsla(%.f, %.f%%, %.f%%, %.2g)", h * 360.0, ss * 100.0, l * 100.0, a],
                    @"autocomplete":[NSString stringWithFormat:@"a(%.f, %.f%%, %.f%%, %.2g)", h * 360.0, ss * 100.0, l * 100.0, a]
                    }
                ];
     }

    NSDictionary *namedColor = [self searchCssNamedColors:hexadecimal usingKey:@"value"];
    if ([namedColor count] > 0) css = [css arrayByAddingObject:@{
                                                                 @"id":@"css-named",
                                                                 @"description":@"CSS • Named Color",
                                                                 @"argument":[namedColor objectForKey:@"name"],
                                                                 @"autocomplete":[namedColor objectForKey:@"name"]
                                                                 }];

    bool classMatch;
    NSMutableArray *formatQueue = [[NSMutableArray alloc] init];

    // Order results (input format is top, followed by related formats)
    for (NSArray *class in @[ns, ui, css])
     {
        for (NSDictionary *format in class)
         {
            if ([[format objectForKey:@"id"] isEqualToString:[self preferredFormatForMostRecentKey]])
             {
                [formatQueue insertObject:format atIndex:0]; // Put this result at the top
                classMatch = YES;
             }
            else
             {
                [formatQueue addObject:format];
             }
         }
        if (classMatch)
         {
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formatQueue count])];
            [sortedArray insertObjects:formatQueue atIndexes:indexes];
            classMatch = NO;
         }
        else [sortedArray addObjectsFromArray:formatQueue];
        [formatQueue removeAllObjects];
     }

    return (NSArray*)sortedArray;
}
- (void) parseHexadecimalString: (NSString*)hexadecimal {
    float r, g, b, a;
    unsigned long rgba = strtoul([hexadecimal UTF8String], NULL, 16);

    r = ((float)((rgba & 0xFF000000) >> 24) / 255.0);
    g = ((float)((rgba & 0xFF0000) >> 16) / 255.0);
    b = ((float)((rgba & 0xFF00) >> 8) / 255.0);
    a = ((float)(rgba & 0xFF) / 255.0);
    [self setColor:[NSColor colorWithCalibratedRed:r
                                             green:g
                                              blue:b
                                             alpha:a]];
}
- (bool) input: (NSString*)query {
    NSMutableArray *queryArray = [[NSMutableArray alloc] init];
    float r, g, b, h, s, ss, l, v, w, a;
    r = g = b = h = w = 0.0;
    s = ss = v = 1.0;
    l = 0.5;
    a = 1.0;

    // Parse logic
    if ([query hasPrefix:@"#"]) // CSS Hexadecimal
     {
        [self setPreferredFormat:@"-hex" forKey:@"css"];

        query = [query stringByPreservingCharactersInString:@"0123456789abcdefABCDEF"];

        if ([query isEqual:@""]) return YES;

        unsigned long queryLength = [query length];
        NSString *expandedQuery = @"";
        NSString *substring;
        for (int i = 0; i < queryLength; i++)
         {
            substring = [query substringWithRange:NSMakeRange(i, 1)];
            if (queryLength <= 3) // Shorthand (e.g. #fff)
             {
                expandedQuery = [expandedQuery stringByAppendingString:substring];
             }
            expandedQuery = [expandedQuery stringByAppendingString:substring];
         }
        query = expandedQuery;

        queryLength = [query length];
        for (int i = 0; i < (8 - queryLength); i++)
         {
            if ([query length] < 6) // first 6 channels always default to 0
             {
                query = [query stringByAppendingString:@"0"];
             }
            else
             {
                if (queryLength > 6)
                 {
                    query = [query stringByAppendingString:@"0"]; // Alpha specified; fill with transparency
                 }
                else
                 {
                    query = [query stringByAppendingString:@"F"]; // No alpha specified; full opacity
                 }
             }
         }
        [self parseHexadecimalString:query];
     }
    else if ([query hasPrefix:@"hsl"]) // CSS HSL
     {
        [self setPreferredFormat:@"-hsl" forKey:@"css"];

        query = [query stringByPreservingCharactersInString:@"0123456789., "];

        if ([query isEqual:@""]) return YES;

        queryArray = [query componentsSeparatedByCharactersInString:@", "];
        if ([queryArray count] > 0) h = [[queryArray objectAtIndex:0] floatValue] / 360.0;
        if ([queryArray count] > 1) ss = [[queryArray objectAtIndex:1] floatValue] / 100.0;
        if ([queryArray count] > 2) l = [[queryArray objectAtIndex:2] floatValue] / 100.0;
        if ([queryArray count] > 3) a = [[queryArray objectAtIndex:3] floatValue] / 1.0;

        // Convert HSL to HSB
        l *= 2.0;
        ss *= (l <= 1.0) ? l : 2.0 - l;
        v = (l + ss) / 2.0;
        s = (2.0 * ss) / (l + ss);
        [self setColor:[NSColor colorWithCalibratedHue:h
                                            saturation:s
                                            brightness:v
                                                 alpha:a]];
     }
    else if ([query hasPrefix:@"rgb"]) // CSS RGB
     {
        [self setPreferredFormat:@"-rgb" forKey:@"css"];

        query = [query stringByPreservingCharactersInString:@"0123456789.%, "];

        if ([query isEqual:@""]) return YES;

        queryArray = [query componentsSeparatedByCharactersInString:@", "];
        float divisor = 255.0;

        // Check for percent sign
        if ([queryArray count] > 0 && [[queryArray objectAtIndex:0] hasSuffix:@"%"])
         {
            [self setPreferredFormat:@"-rgb%" forKey:@"css"];
            divisor = 100.0;
         }

        // After checking, strip percent signs and re-generate
        query = [query stringByPreservingCharactersInString:@"0123456789., "];
        queryArray = [query componentsSeparatedByCharactersInString:@", "];

        if ([queryArray count] > 0) r = [[queryArray objectAtIndex:0] floatValue] / divisor;
        if ([queryArray count] > 1) g = [[queryArray objectAtIndex:1] floatValue] / divisor;
        if ([queryArray count] > 2) b = [[queryArray objectAtIndex:2] floatValue] / divisor;
        if ([queryArray count] > 3) a = [[queryArray objectAtIndex:3] floatValue];

        [self setColor:[NSColor colorWithCalibratedRed:r
                                                 green:g
                                                  blue:b
                                                 alpha:a]];
     }
    else if ([query hasPrefix:@"["]) // NSColor and UIColor
     {
        NSString *format;
        if ([query hasPrefix:@"[NS"])
         {
            format = @"ns";
         }
        else if ([query hasPrefix:@"[UI"])
         {
            format = @"ui";
         }
        else
         {
            return NO;
         }
        NSString *model = @"-rgb";
        query = [query lowercaseString];

        NSString *componentQuery = query;
        componentQuery = [componentQuery stringByReplacingOccurrencesOfString:@"co" withString:@""]; // 'color' == 'c'
        componentQuery = [componentQuery stringByReplacingOccurrencesOfString:@"ed" withString:@""]; // 'calibrated' == 'd'
        componentQuery = [componentQuery stringByReplacingOccurrencesOfString:@"ic" withString:@""]; // 'device' == 'c'
        componentQuery = [componentQuery stringByReplacingOccurrencesOfString:@"with" withString:@""]; // 'with' == 'w' & 'h'
        componentQuery = [componentQuery stringByReplacingOccurrencesOfString:@"gh" withString:@""]; // 'brightness' == 'h'
        componentQuery = [componentQuery stringByReplacingOccurrencesOfString:@"ph" withString:@""]; // 'alpha' == 'h'

        componentQuery = [componentQuery stringByPreservingCharactersInString:@"0123456789.whcd \t\n"];

        if ([query isEqual:@""])
         {
            [self setMostRecentKey:format];
            return YES;
         }

        queryArray = [query componentsSeparatedByCharactersInString:@" \t\n"];

        if ([queryArray count] > 0)
         {
            NSString *firstComponent = [queryArray objectAtIndex:0];
            NSString *nsModelPrefix = @"-calibrated";

            if ([format isEqual:@"ns"])
             {
                if ([firstComponent rangeOfString:@"d"].location != NSNotFound)
                 {
                    firstComponent = [firstComponent stringByReplacingOccurrencesOfString:@"d" withString:@""];
                    nsModelPrefix = @"-device";
                 }
             }


            if ([firstComponent hasPrefix:@"w"]) model = @"-white";
            else if ([firstComponent hasPrefix:@"h"]) model = @"-hsb";

            if ([format isEqual:@"ns"]) model = [nsModelPrefix stringByAppendingString:model];

            firstComponent = [firstComponent stringByPreservingCharactersInString:@"0123456789."];
            if ([firstComponent isEqual:@""]) [queryArray removeObjectAtIndex:0];
            else [queryArray replaceObjectAtIndex:0 withObject:firstComponent];
         }

        [self setPreferredFormat:model forKey:format];

        if ([queryArray count] == 0) return YES;

        if ([model hasSuffix:@"rgb"])
         {
            if ([queryArray count] > 0) r = [[queryArray objectAtIndex:0] floatValue];
            if ([queryArray count] > 1) g = [[queryArray objectAtIndex:1] floatValue];
            if ([queryArray count] > 2) b = [[queryArray objectAtIndex:2] floatValue];
            if ([queryArray count] > 3) a = [[queryArray objectAtIndex:3] floatValue];

            if ([queryArray count] > 0) [self setColor:[NSColor colorWithCalibratedRed:r
                                                                                 green:g
                                                                                  blue:b
                                                                                 alpha:a]];
         }
        else if ([model hasSuffix:@"white"])
         {
            if ([queryArray count] > 0) w = [[queryArray objectAtIndex:0] floatValue];
            if ([queryArray count] > 1) a = [[queryArray objectAtIndex:1] floatValue];

            if ([queryArray count] > 0) [self setColor:[NSColor colorWithCalibratedWhite:w
                                                                                   alpha:a]];
         }
        else if ([model hasSuffix:@"hsb"])
         {
            if ([queryArray count] > 0) h = [[queryArray objectAtIndex:0] floatValue];
            if ([queryArray count] > 1) s = [[queryArray objectAtIndex:1] floatValue];
            if ([queryArray count] > 2) v = [[queryArray objectAtIndex:2] floatValue];
            if ([queryArray count] > 3) a = [[queryArray objectAtIndex:3] floatValue];

            if ([queryArray count] > 0) [self setColor:[NSColor colorWithCalibratedHue:h
                                                                            saturation:s
                                                                            brightness:v
                                                                                 alpha:a]];
         }
        else // Search named colors
         {
            if ([format isEqual:@"ns"] || [format isEqual:@"ui"])
             {
                // Search Objective-C named colors
             }
            if ([format isEqual:@"ns"])
             {
                // Search NS named colors
             }
            else
             {
                return NO;
             }
         }
     }
    else // Nothing else matches; check CSS named colors
     {
        query = [query lowercaseString];
        query = [query stringByPreservingCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];

        if ([query isEqual:@""]) return YES; // Stop trying to parse. No point.

        NSDictionary *match = [self searchCssNamedColors:query usingKey:@"name"];
        if ([match count] == 0)
         {
            [self setMostRecentKey:@"css"];
            return YES;
         }
        else
         {
            [self setPreferredFormat:@"-named" forKey:@"css"];
            [self parseHexadecimalString:[match objectForKey:@"value"]];
         }
     }

    return NO; // The parser should never make it to this point, but just in case...
}

- (void) setMostRecentKey: (NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:key forKey:@"mostRecentKey"];
    [defaults synchronize];
}
- (NSString*) mostRecentKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *mostRecentKey = [defaults objectForKey:@"mostRecentKey"];

    if (!mostRecentKey)
     {
        [self setMostRecentKey:@"css"]; // Default to CSS
        mostRecentKey = @"css";
     }

    return mostRecentKey;
}
- (void) setPreferredFormat: (NSString*)format forKey: (NSString*)key {
    [self setMostRecentKey:key];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:format forKey:key];
    [defaults synchronize];
}
- (NSString*) preferredFormatForKey: (NSString*)key {
    NSString *format = [[NSUserDefaults standardUserDefaults] objectForKey:key];

    if (!format)
     {
        if ([key isEqual:@"ns"]) format = @"-calibrated"; // NSColor defaults to Calibrated

        format = [format stringByAppendingString:@"-rgb"]; // Always default to RGB
        [self setPreferredFormat:format forKey:key];
     }

    return [key stringByAppendingString:format];
}
- (NSString*) preferredFormatForMostRecentKey {
    return [self preferredFormatForKey:[self mostRecentKey]];
}
- (NSDictionary*) searchCssNamedColors: (NSString*)query usingKey:(NSString*)key {
    NSPredicate *predicate;

    if ([key isEqualToString:@"name"])
     {
        query = [query lowercaseString];
        query = [query stringByPreservingCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];

        predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@", query];
     }
    else if ([key isEqualToString:@"value"])
     {
        query = [query lowercaseString];

        predicate = [NSPredicate predicateWithFormat:@"value BEGINSWITH %@", query];
     }
    else
     {
        return @{};
     }

    NSArray *matches = [[NSColor cssNamedColors] filteredArrayUsingPredicate:predicate];
    if ([matches count] > 0) return [matches objectAtIndex:0];
    else return @{};
}
- (void) setToggleAlpha: (bool)value {
    toggleAlpha = value;
}
- (bool) toggleAlpha {
    return toggleAlpha;
}
- (void) setColor: (NSColor*)newColor {
    color = [newColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}
- (NSColor*) color {
    return color;
}
- (NSString*) formattedInput: (bool)alfredSafe {
    NSString *safeInputFormat = [self preferredFormatForMostRecentKey];
    NSString *alternativeSuffix = @"";

    if (alfredSafe && [safeInputFormat isEqual:@"css-named"]) safeInputFormat = @"css-rgb";
    if ([safeInputFormat hasPrefix:@"ns"] || [safeInputFormat hasPrefix:@"ui"])
     {
        if ([safeInputFormat hasSuffix:@"rgb"] || [safeInputFormat hasSuffix:@"hsb"]) alternativeSuffix = @"white";
        if ([safeInputFormat hasSuffix:@"white"]) alternativeSuffix = @"rgb";
     }

    NSString *prefix = [[safeInputFormat componentsSeparatedByString:@"-"] objectAtIndex:0];

    for (NSDictionary *format in [self output])
     {
        NSString *formatId = [format objectForKey:@"id"];
        if ([formatId isEqual:safeInputFormat] || (![alternativeSuffix isEqual:@""] && [formatId hasSuffix:alternativeSuffix] && [formatId hasPrefix:prefix]))
         {
            return [format objectForKey:@"argument"];
         }
     }
    return @"";
}
- (void) sendToAlfred {
    NSString *formattedInput = [self formattedInput:YES];

    NSString *source = [NSString stringWithFormat:@"tell application \"Alfred 2\" to search \"%@\"", formattedInput];
    NSAppleScript *applescript = [[NSAppleScript alloc] initWithSource:source];

    [applescript executeAndReturnError:nil];
}
@end