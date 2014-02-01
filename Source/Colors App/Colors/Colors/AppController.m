//
//  colors.m
//  Color-Picker
//
//  Created by Tyler on 10/3/13.
//  Copyright (c) 2013 Tyler. All rights reserved.
//

#import "AppController.h"

@implementation NSColor (Colors)
+ (NSColor*) initWithComponentString: (NSString*)string {
    float r, g, b, a;
    r = g = b = 0.0;
    a = 1.0;
    NSArray *array = [string componentsSeparatedByString:@" "];

    if ([array count] > 0) r = [[array objectAtIndex:0] floatValue];
    if ([array count] > 1) g = [[array objectAtIndex:1] floatValue];
    if ([array count] > 2) b = [[array objectAtIndex:2] floatValue];
    if ([array count] > 3) a = [[array objectAtIndex:3] floatValue];
    return [NSColor colorWithCalibratedRed:r
                                     green:g
                                      blue:b
                                     alpha:a];
}
@end

@implementation AppController
- (void) awakeFromNib {
    NSArray *arguments = [[NSProcessInfo alloc] arguments];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSColor *color;
    NSString *componentString = @"0 0 0 1";
    if ([arguments count] > 1 && ([[arguments objectAtIndex:1] rangeOfString:@" "].location != NSNotFound))
     {
        componentString = [arguments objectAtIndex:1];
        color = [NSColor initWithComponentString:componentString];
     }
    else if ([defaults dataForKey:@"color"])
     {
        color = [NSUnarchiver unarchiveObjectWithData:[defaults dataForKey:@"color"]];
     }

    NSButton *choose = [[NSButton alloc] initWithFrame:NSMakeRect(80, 2, 80, 28)];
    [choose setButtonType:NSMomentaryPushInButton];
    [choose setBezelStyle:NSRoundedBezelStyle];
    choose.title = @"Choose";
    choose.action = @selector(output);
    choose.target = self;

    NSButton *cancel = [[NSButton alloc] initWithFrame:NSMakeRect(0, 2, 80, 28)];
    [cancel setButtonType:NSMomentaryPushInButton];
    [cancel setBezelStyle:NSRoundedBezelStyle];
    cancel.title = @"Cancel";
    cancel.action = @selector(exit);
    cancel.target = self;

    NSView *accessoryView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 160, 30)];
    [accessoryView addSubview:choose];
    [accessoryView addSubview:cancel];

    colorPanel = [NSColorPanel sharedColorPanel];
    [colorPanel setTitle:@"OS X Color Panel"];
    [colorPanel setFloatingPanel:YES];
    [colorPanel setShowsAlpha:YES];
    [colorPanel setColor:color];
    [colorPanel setDelegate:self];
    [colorPanel setHidesOnDeactivate:NO];
    [colorPanel setAccessoryView:accessoryView];
    [colorPanel setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorFullScreenAuxiliary];
    [colorPanel setDefaultButtonCell:[choose cell]];

    [colorPanel makeKeyAndOrderFront:nil];
}

- (void) output {
    NSColor *color = [[colorPanel color] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    printf("%f %f %f %f", [color redComponent], [color greenComponent], [color blueComponent], [color alphaComponent]);
    [self exit];
}

- (void) exit {
    [NSApp terminate:self];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication*)theApplication {
    NSEventType type = [[theApplication currentEvent] type];
    if (type == NSSystemDefined)
     {
        return NO;
     }
    else
     {
        return YES;
     }
}

- (void) applicationWillTerminate: (id)sender {
    NSColor *color = [colorPanel color];
    NSData *data = [NSArchiver archivedDataWithRootObject:color];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"color"];
    [defaults synchronize];
}
@end