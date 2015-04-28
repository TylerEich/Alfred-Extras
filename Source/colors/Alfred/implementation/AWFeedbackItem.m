//
//  AWFeedbackItem.m
//  AlfredWorkflow
//
//  Created by Daniel Shannon on 5/24/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import "AWFeedbackItem.h"
#import "NSString+XMLEscaping.h"

@implementation AWFeedbackItem

+ (id)itemWithObjectsAndKeys:(id)o, ...
{
    va_list args;
    va_start(args, o);
    int i = 0;

    AWFeedbackItem *item = [[AWFeedbackItem alloc] init];

    NSMutableArray *k = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *v = [[NSMutableArray alloc] initWithCapacity:0];

    id arg = o;
    do {
        if (i % 2 == 0) {
            [v addObject:arg];
        } else if (i % 2 != 0) {
            if ([[arg className] rangeOfString:@"String"].location != NSNotFound)
                [k addObject:arg];
        }
        i++;
    } while ((arg = va_arg(args, id)));
    va_end(args);

    NSDictionary *kv = [NSDictionary dictionaryWithObjects:v forKeys:k];
    [item setValuesForKeysWithDictionary:kv];
    
    return item;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _title = @"";
        _subtitle = @"";
        _icon = @"icon.png";
		// additional properties to support modifier subtitles
		_subShift = @"";
		_subFn = @"";
		_subCtrl = @"";
		_subAlt = @"";
		_subCmd = @"";

        _uid = nil;
        _valid = @NO;
        _autocomplete = nil;
        _arg = nil;

        _fileicon = nil;
        _filetype = nil;
        _type = nil;

        self->tags_ = [NSArray arrayWithObjects:@"title", @"subtitle", @"icon", nil];
        self->attrib_ = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"uid", @"valid", @"autocomplete", @"type", nil], @"item", [NSArray arrayWithObjects:@"fileicon", @"filetype", nil], @"icon", nil];
    }
    
    return self;
}

- (id)initWithObjects:(NSArray *)obj forKeys:(NSArray *)key
{
    if ([obj count] != [key count]) {
        return nil;
    }

    self = [[super init] init];
    if (self != nil) {
        for (NSUInteger i = 0; i < [obj count]; i++) {
            id v = [obj objectAtIndex:i];
            NSString *k = [key objectAtIndex:i];
            [self setValue:v forKey:k];
        }
    }

    return self;
}

- (NSString *)xml
{
    NSString *x = [NSString string];

    NSString *i = @"<item";
    for (NSString *k in [self->attrib_ objectForKey:@"item"]) {
        id v = [self valueForKey:k];
        if(v != nil) {
            if ([v respondsToSelector:@selector(escapedString)]) {
                v = [v escapedString];
            }
            if ([k isEqualToString:@"valid"])
                v = [v boolValue] ? @"yes" : @"no";
            i = [i stringByAppendingFormat:@" %@=\"%@\"", k, v];
        }
    }
    if (self.arg != nil && [self.arg rangeOfString:@"\n"].location == NSNotFound)
    {
        i = [i stringByAppendingFormat:@" arg=\"%@\"", [self.arg escapedString]];
    }
    i = [i stringByAppendingString:@">"];
    x = [x stringByAppendingString:i];

    for (NSString *k in self->tags_) {
        id v = [self valueForKey:k];

        if (v != nil) {
            NSString *strV = [NSString stringWithFormat:@"%@", v];
            strV = [strV escapedString];

            NSArray *attr = [self->attrib_ objectForKey:k];
            NSMutableString *format = [NSMutableString stringWithFormat:@"<%@", k];
            if (attr != nil) {
                for (NSString *a in attr) {
                    NSString *av;
                    if ([a isEqualToString:@"valid"])
                    {
                        if (self.valid != nil)
                        {
                            av = [self.valid boolValue] ? @"yes" : @"no";
                        }
                    }
                    else if ([a isEqualToString:@"fileicon"])
                    {
                        if (self.fileicon != nil)
                        {
                            av = [self.fileicon boolValue] ? @"yes" : @"no";
                        }
                    }
                    else if ([a isEqualToString:@"filetype"])
                    {
                        if (self.filetype != nil)
                        {
                            av = [self.filetype boolValue] ? @"yes" : @"no";
                        }
                    }
                    else if ([self valueForKey:a] != nil)
                        av = [self valueForKey:a];

                    if (av != nil)
                        [format appendFormat:@" %@=\"%@\"", a, av];
                }
            }
            [format appendString:@">"];
            x = [x stringByAppendingFormat:@"%@%@</%@>", format, strV, k];
        }
    }
    if (self.arg != nil && [self.arg rangeOfString:@"\n"].location != NSNotFound)
    {
        x = [x stringByAppendingFormat:@"<arg>%@</arg>", [self.arg escapedString]];
    }

	// additional properties to support modifier subtitles
	if (![_subShift isEqualToString:@""])
        x = [x stringByAppendingFormat:@"<subtitle mod=\"shift\">%@</subtitle>", _subShift];
	if (![_subFn isEqualToString:@""])
        x = [x stringByAppendingFormat:@"<subtitle mod=\"fn\">%@</subtitle>", _subFn];
	if (![_subCtrl isEqualToString:@""])
        x = [x stringByAppendingFormat:@"<subtitle mod=\"ctrl\">%@</subtitle>", _subCtrl];
	if (![_subAlt isEqualToString:@""])
        x = [x stringByAppendingFormat:@"<subtitle mod=\"alt\">%@</subtitle>", _subAlt];
	if (![_subCmd isEqualToString:@""])
        x = [x stringByAppendingFormat:@"<subtitle mod=\"cmd\">%@</subtitle>", _subCmd];

    x = [x stringByAppendingString:@"</item>"];

    return x;
}

@end
