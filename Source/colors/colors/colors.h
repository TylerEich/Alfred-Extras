//
//  colors.h
//  Color-Picker
//
//  Created by Tyler on 10/3/13.
//  Copyright (c) 2013 Tyler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <Alfred/Alfred.h>
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
- (NSString*) formattedInput: (bool)alfredSafe;
- (void) savePreviewToPath: (NSString*)path;
- (void) sendToAlfred;
@end

@interface NSString (Colors)
- (NSString*) stringByPreservingCharactersInString: (NSString*)preservedCharacters;
- (NSMutableArray*) componentsSeparatedByCharactersInString: (NSString*)separatorCharacters;
@end

@interface NSColor (Colors)
- (NSString*) hexadecimal;
+ (NSArray*) namedColors;
@end

@interface NSImage (Colors)
- (void) saveAtPath: (NSString*)path;
@end