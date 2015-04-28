//
//  NSArray+FuzzySearching.m
//  alfred
//
//  Created by Daniel Shannon on 5/25/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import <objc/objc-runtime.h>
#import "NSArray+FuzzySearching.h"

static const void *KEY;

@implementation NSArray (FuzzySearching)

# pragma mark -
# pragma mark NSArray+FuzzySearching

- (NSArray *)orderElementsOfArray:(NSArray *)x decreasing:(BOOL)decreasing
{
    NSInteger n = [x count];
    NSMutableArray *ix = [[NSMutableArray alloc] initWithCapacity:[x count]];
    for (NSInteger i = 0; i < n; i++)
    {
        [ix insertObject:[NSNumber numberWithInteger:i] atIndex:i];
    }

    [ix sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        NSInteger x1 = [[x objectAtIndex:[obj1 integerValue]] integerValue];
        NSInteger x2 = [[x objectAtIndex:[obj2 integerValue]] integerValue];

        if (x1 > x2)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (x1 < x2)
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

    return ix;
}

- (NSArray *)rankElementsOfArray:(NSArray *)x decreasing:(BOOL)dec
{
    NSMutableArray *O = [[NSMutableArray alloc] initWithArray:[self orderElementsOfArray:x decreasing:dec]];
    NSMutableArray *R = [[NSMutableArray alloc] initWithArray:O copyItems:YES];
    NSInteger n = [O count];
    for (NSInteger i = 0; i < n; i++)
    {
        [R replaceObjectAtIndex:[[O objectAtIndex:i] integerValue] withObject:[NSNumber numberWithInteger:i]];
    }

    return R;
}

- (NSArray *)rankMatchesForQuery:(NSString *)query inStrings:(NSArray *)strings
{
    NSMutableArray *data = [[NSMutableArray alloc] initWithArray:strings copyItems:YES];
    NSString *fmt = @"[^%@]*(%@)";
    NSMutableString *regex = [[NSMutableString alloc] initWithCapacity:0];
    for (NSUInteger i = 0; i < [query length]; i++)
    {
        NSRange r = NSMakeRange(i, 1);
        NSString *ss = [query substringWithRange:r];
        [regex appendFormat:fmt, ss, ss];
    }
    NSError *reer = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:&reer];
    if (reer)
    {
        [self.fuzzy_delegate threwError:[reer localizedDescription]];
        return nil;
    }

    NSMutableArray *mat = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSArray *v in strings)
    {
        NSString *s = [v objectAtIndex:1];
        NSUInteger index = [query length] >= 3 ? 3 : [query length];
        if ([s rangeOfString:[query substringToIndex:index] options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)].location != NSNotFound)
        {
            NSArray *m = [re matchesInString:s options:NSMatchingReportCompletion range:NSMakeRange(0, [s length])];
            [mat addObject:m];
        }
        else
        {
            [data removeObject:v];
        }
    }

    NSMutableArray *position = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSArray *m in mat)
    {
        NSMutableArray *sequence = [[NSMutableArray alloc] init];
        for (NSTextCheckingResult *tcr in m)
        {
            NSInteger groups = [tcr numberOfRanges];
            NSMutableArray *per_group = [[NSMutableArray alloc] init];
            for (NSInteger i = 1; i < groups; i++)
            {
                NSRange r = [tcr rangeAtIndex:i];
                NSInteger p = r.location + r.length;
                [per_group addObject:[NSNumber numberWithInteger:p]];
            }
            [sequence addObjectsFromArray:per_group];
        }
        [position addObject:sequence];
    }

    NSMutableArray *letter_seq = [[NSMutableArray alloc] init];
    for (NSArray *pos in position)
    {
        NSInteger seq = 0;
        for (NSInteger i = 1; i < [pos count]; i++)
        {
            NSInteger p = [[pos objectAtIndex:i] integerValue];
            seq += (p - [pos[i-1] integerValue]) == 1;
        }
        [letter_seq addObject:[NSNumber numberWithInteger:seq]];
    }

    NSMutableArray *pos_sum = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSArray *pos in position) {
        NSInteger sum = 0;
        for (NSInteger i = 0; i < [pos count]; i++) {
            sum += [[pos objectAtIndex:i] integerValue];
        }
        [pos_sum addObject:[NSNumber numberWithInteger:sum]];
    }

    NSArray *rank_seq = [self rankElementsOfArray:letter_seq decreasing:YES];
    NSArray *rank_sum = [self rankElementsOfArray:pos_sum decreasing:NO];
    NSMutableArray *O = [[NSMutableArray alloc] initWithCapacity:[rank_seq count]];
    for (NSInteger i = 0; i < [rank_seq count]; i++) {
        float r_sq = [[rank_seq objectAtIndex:i] floatValue];
        float r_sm = [[rank_sum objectAtIndex:i] floatValue];
        float div = (r_sq + r_sm) / 2.0;
        NSArray *datum = [data objectAtIndex:i];
        [O addObject:@[[NSNumber numberWithFloat:div], datum]];
    }

    return O;
}

- (NSArray *)fuzzySearchFor:(NSString *)query withKeyBlock:(NSString *(^)(id))key
{
    NSMutableArray *strings = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id el in self)
    {
        [strings addObject:@[el, key(el)]];
    }
    NSArray *R = [self rankMatchesForQuery:query inStrings:strings];
    NSMutableArray *O = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [R count]; i++)
    {
        [O insertObject:@[[NSNumber numberWithFloat:[[[R objectAtIndex:i] objectAtIndex:0] floatValue]],[[R objectAtIndex:i] objectAtIndex:1]] atIndex:i];
    }
    [O sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        NSArray *o1 = (NSArray *)obj1;
        NSArray *o2 = (NSArray *)obj2;
        float r1 = [[o1 objectAtIndex:0] floatValue];
        float r2 = [[o2 objectAtIndex:0] floatValue];

        if (r1 > r2)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (r1 < r2)
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray *O_ = [[NSMutableArray alloc] initWithCapacity:[O count]];
    for (NSInteger i = 0; i < [O count]; i++)
    {
        [O_ insertObject:[[[O objectAtIndex:i] objectAtIndex:1] objectAtIndex:0] atIndex:i];
    }

    return O_;
}




# pragma mark -
# pragma mark Delegate methods

- (void)setFuzzy_delegate:(id<AWFuzzySearchingDelegate>)fd
{
    objc_setAssociatedObject(self, KEY, fd, OBJC_ASSOCIATION_RETAIN);
}

- (id<AWFuzzySearchingDelegate>)fuzzy_delegate
{
    return objc_getAssociatedObject(self, KEY);
}

@end
