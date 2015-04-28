//
//  NSArray+FuzzySearching.h
//  alfred
//
//  Created by Daniel Shannon on 5/25/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AWFuzzySearchingDelegate;

@interface NSArray (FuzzySearching)

- (NSArray *)orderElementsOfArray:(NSArray *)x decreasing:(BOOL)decreasing;
- (NSArray *)rankElementsOfArray:(NSArray *)x decreasing:(BOOL)dec;
- (NSArray *)rankMatchesForQuery:(NSString *)query inStrings:(NSArray *)strings;
- (NSArray *)fuzzySearchFor:(NSString *)query withKeyBlock:(NSString *(^)(id))key;

- (void)setFuzzy_delegate:(id<AWFuzzySearchingDelegate>)fd;
- (id<AWFuzzySearchingDelegate>)fuzzy_delegate;


@end





# pragma mark -
# pragma mark Delegate protocol

@protocol AWFuzzySearchingDelegate <NSObject>

- (void)threwError:(NSString *)e;

@end
