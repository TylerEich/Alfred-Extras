//
//  colors.h
//  Color-Picker
//
//  Created by Tyler on 10/3/13.
//  Copyright (c) 2013 Tyler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <math.h>

@interface NSColor (Colors)
+ (NSColor*) initWithComponentString: (NSString*)string;
@end

@interface AppController : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    NSColorPanel *colorPanel;
}
- (void) exit;
- (void) output;
@end

