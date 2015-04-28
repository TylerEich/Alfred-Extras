//
//  colors.h
//  Color-Picker
//
//  Created by Tyler on 10/3/13.
//  Copyright (c) 2013 Tyler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "../Alfred/headers/Alfred.h"
#import <math.h>

@interface Colors : NSObject
{
    NSColor *color;
    NSString *inputFormat;
    bool toggleAlpha;
}
- (NSArray*) output;
- (void) feedback;
- (void) fallbackToColorPanelResult: (NSString*)title;
- (void) fallbackToColorPanelResult;
- (void) openColorPanel;
- (void) parseHexadecimalString: (NSString*)hexadecimal;
- (bool) input: (NSString*)query;
- (NSColor*) color;
- (void) setColor: (NSColor*)color;
- (bool) toggleAlpha;
- (void) setToggleAlpha: (bool)value;
- (NSString*) formattedInput;
- (void) savePreviewToPath: (NSString*)path;
- (void) sendToAlfred;
@end

@interface NSString (Colors)
- (NSString*) stringByPreservingCharactersInString: (NSString*)preservedCharacters;
- (NSMutableArray*) componentsSeparatedByCharactersInString: (NSString*)separatorCharacters;
@end

@interface NSColor (Colors)
- (NSString*) hexadecimal;

- (NSColor*) colorWithOffsetHue: (float)hueOffset
                     saturation: (float)saturationOffset
                     brightness: (float)brightnessOffset
                          alpha: (float)alphaOffset;
- (NSColor*) complement;
- (NSColor*) triadByDecimal: (float)decimal;
- (NSColor*) tetradByDecimal: (float)decimal
           fromComplementary: (bool)fromComplementary;
- (NSColor*) analogicByDecimal: (float)decimal;
- (NSColor*) brightenByDecimal: (float)decimal;
- (NSColor*) saturateByDecimal: (float)decimal;

+ (NSArray*) cssNamedColors;
+ (NSArray*) objCNamedColors;
@end

@interface NSImage (Colors)
- (void) saveAtPath: (NSString*)path;
@end