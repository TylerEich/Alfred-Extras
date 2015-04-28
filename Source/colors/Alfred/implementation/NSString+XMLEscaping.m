//
//  NSString+XMLEscaping.m
//  AlfredWorkflow
//
//  Created by Daniel Shannon on 5/24/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import "NSString+XMLEscaping.h"

@implementation NSString (XMLEscaping)

- (NSString *)escapedString
{
    NSMutableString *esc = [[NSMutableString alloc] initWithString:self];
    NSRange whole = NSMakeRange(0, [self length]);

    [esc replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:whole];
    whole = NSMakeRange(0, [esc length]);
    [esc replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:whole];
    whole = NSMakeRange(0, [esc length]);
    [esc replaceOccurrencesOfString:@"'" withString:@"&apos;" options:NSLiteralSearch range:whole];
    whole = NSMakeRange(0, [esc length]);
    [esc replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:whole];
    whole = NSMakeRange(0, [esc length]);
    [esc replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:whole];

    return esc;
}

@end
