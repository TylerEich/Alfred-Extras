//
//  AWArgs.m
//  Alfred
//
//  Created by Daniel Shannon on 5/26/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#include <getopt.h>
#import <objc/objc-runtime.h>
#import "AWArgs.h"

@interface AWArgs ()

@property (readwrite) const char    **argv;
@property (readwrite) int             argc;
@property (readwrite) NSArray        *keys;
@property (readwrite) NSDictionary   *val_;

@end

@implementation AWArgs

- (id)initWithArgs:(const char *[])argv andKeys:(NSArray *)keys count:(int)argc 
{
    self = [super init];
    if (self != nil) {
        _argv = argv;
        _argc = argc;
        _keys = keys;
    }
    return self;
}

- (NSDictionary *)parse
{
    if (self.argc == 1) {
        return [NSDictionary dictionary];
    }

    int c;
    int o = (int)[self.keys count] + 1;
    NSMutableString *fmt = [[NSMutableString alloc] initWithCapacity:self.argc];
    struct option long_options[o];
    memset(&long_options, 0, sizeof(struct option)*o);
    for (int i = 0; i < [self.keys count]; i++) {
        NSDictionary *kv = [self.keys objectAtIndex:i];
        NSString *name = [kv objectForKey:@"name"];
        const char *n = [name UTF8String];
        NSNumber *has_arg = [kv objectForKey:@"has_arg"];
        int h_a;
        NSString *fl = [kv objectForKey:@"flag"];
        unichar flag = [fl characterAtIndex:0];
        if ([has_arg isEqualToNumber:@YES]) {
            h_a = required_argument;
            [fmt appendFormat:@"%@:", fl];
        } else if ([has_arg isEqualToNumber:@NO]) {
            h_a = no_argument;
            [fmt appendString:fl];
        } else {
            h_a = optional_argument;
            [fmt appendFormat:@"%@::", fl];
        }

        long_options[i].name = n;
        long_options[i].has_arg = h_a;
        long_options[i].flag = NULL;
        long_options[i].val = flag;
    }
    int last = o - 1;
    long_options[last].name = 0;
    long_options[last].has_arg = 0;
    long_options[last].flag = 0;
    long_options[last].val = 0;

    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithCapacity:0];
    int option_index = 0;
    while (YES) {
        c = getopt_long(self.argc, (char * const *)self.argv, [fmt UTF8String], long_options, &option_index);

        if (c == -1) {
            break;
        } else {
            NSString *k = [NSString stringWithCString:long_options[option_index].name encoding:NSUTF8StringEncoding];
            id v = nil;
            if (optarg) {
                v = [NSString stringWithCString:optarg encoding:NSUTF8StringEncoding];
            } else {
                v = @YES;
            }
            [d setObject:v forKey:k];
        }
    }

    int _i = -1;
    for (int i = 1; i < self.argc; i++) {
        NSString *arg = [NSString stringWithCString:self.argv[i] encoding:NSUTF8StringEncoding];
        if ([arg rangeOfString:@"--"].location == NSNotFound) {
            _i = i; // First non-option argument.
            break;
        }
    }

    if (_i == -1)
    {
        [d setObject:@NO forKey:@"{query}"];
    }
    else
    {
        NSMutableString *q = [[NSMutableString alloc] initWithCapacity:0];
        for (int j = _i; j < self.argc; j++) {
            NSString *s = [NSString stringWithCString:self.argv[j] encoding:NSUTF8StringEncoding];
            [q appendFormat:@"%@ ", s];
        }
        q = [NSMutableString stringWithString:[q stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [d setObject:q forKey:@"{query}"];
    }

    return d;
}



@end
