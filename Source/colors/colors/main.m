//
//  main.c
//  colors
//
//  Created by Tyler on 10/5/13.
//  Copyright (c) 2013 Tyler. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import "colors.h"
#import <stdio.h>

int main(int argc, const char *argv[])
{

    AWWorkflow *workflow = [AWWorkflow workflow];
    NSArray *keys = @[
                      @{
                          @"name": @"check",
                          @"has_arg": @NO,
                          @"flag": @"c"
                          },
                      @{
                          @"name": @"flush",
                          @"has_arg": @NO,
                          @"flag": @"f"
                          },
                      @{
                          @"name": @"reveal",
                          @"has_arg": @NO,
                          @"flag": @"r"
                          },
                      @{
                          @"name": @"toggle-alpha",
                          @"has_arg": @NO,
                          @"flag": @"a"
                          }
                      ];
    NSDictionary *arguments = [workflow parseArguments:argv withKeys:keys count:argc];
    NSString *query = [arguments objectForKey:@"{query}"];
    bool check = [arguments objectForKey:@"check"] == nil ? NO : YES;
    bool flush = [arguments objectForKey:@"flush"] == nil ? NO : YES;
    bool reveal = [arguments objectForKey:@"reveal"] == nil ? NO : YES;
    bool toggleAlpha = [arguments objectForKey:@"toggle-alpha"] == nil ? NO : YES;
    Colors *colors = [[Colors alloc] init];

    if (!check && !flush && !reveal && !toggleAlpha) // No flags; live feedback mode
     {
        if ([query length] == 0)
         {
            [colors fallbackToColorPanelResult];
         }

        if ([colors input:query]) [colors fallbackToColorPanelResult:@"No Results"];

        [colors feedback];
     }
    if (check)
     {
        if ([query length] == 0) // No input; reveal color panel
         {
            [colors openColorPanel];
         }
        else
         {
            printf("%s", [query UTF8String]); // Return the input
         }
     }
    else if (flush)
     {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:[workflow cache] error:NULL];
        for (NSString *filename in fileArray)  {
            [fileManager removeItemAtPath:[[workflow cache] stringByAppendingPathComponent:filename] error:NULL];
        }
     }
    else if (reveal)
     {
        [colors input:query];
        [colors openColorPanel];
     }
    else if (toggleAlpha)
     {
        [colors setToggleAlpha:YES];
        [colors input:query];
        NSString *output = [colors formattedInput:NO];
        printf("%s", [output UTF8String]);
     }
}