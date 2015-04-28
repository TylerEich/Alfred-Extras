//
//  AWWorkflow.m
//  alfred
//
//  Created by Daniel Shannon on 5/25/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import "AWWorkflow.h"
#import "NSFileManager+AWFindOrCreate.h"
#import "AWFeedbackItem.h"
#import "NSArray+FuzzySearching.h"
#import "AWPreferences.h"
#import "AWArgs.h"

@interface AWWorkflow () <AWFuzzySearchingDelegate>

@property (readwrite) NSString *bid;

@end

@implementation AWWorkflow

# pragma mark -
# pragma mark Internal methods

+ (id)workflow
{
    return [[AWWorkflow alloc] init];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _bid = [self bundleID];
    }

    return self;
}

# pragma mark -
# pragma mark Bundle methods

- (void)log:(NSString *)s, ...
{
    va_list args;
    va_start(args, s);
    NSString *msg = [[NSString alloc] initWithFormat:[s stringByAppendingString:@"\n"] arguments:args];
    va_end(args);

    NSString *logloc = [self local:@"framework.log"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:logloc]) {
        [[NSFileManager defaultManager] createFileAtPath:logloc
                                                contents:[msg dataUsingEncoding:NSUTF8StringEncoding]
                                              attributes:nil];
    } else {
        NSFileHandle *f = [NSFileHandle fileHandleForUpdatingAtPath:logloc];
        [f seekToEndOfFile];
        [f writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
        [f closeFile];
    }
}

- (NSString *)bundleID
{
    if (!self.bid) {
        NSString *plist_path = [self local:@"info.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plist_path]) {
            [self log:@"Could not open %@", plist_path];
            return nil;
        }
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plist_path];
        NSPropertyListFormat format;
        NSString *err = nil;
        NSDictionary *plistDict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML
                                                                                   mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                                             format:&format
                                                                                   errorDescription:&err];
        if (!plistDict) {
            [self log:@"Error reading %@: %@, format %d", plist_path, err, format];
            return nil;
        }
        self.bid = [plistDict objectForKey:@"bundleid"];
    }

    return self.bid;
}





# pragma mark -
# pragma mark Folder methods

- (NSString *)local
{
    return [[NSBundle mainBundle] bundlePath];
}

- (NSString *)local:(NSString *)filename
{
    return [[self local] stringByAppendingPathComponent:filename];
}

- (NSString *)cache
{
    NSString *c = [[NSFileManager defaultManager] cacheDirectory];
    NSString *bid = [self bundleID];
    if (c != nil) {
        c = [[[c stringByAppendingPathComponent:@"com.runningwithcrayons.Alfred-2"] stringByAppendingPathComponent:@"Workfow Data"]
             stringByAppendingPathComponent:bid];

    }
    [[NSFileManager defaultManager] createIfNonexistent:c];
    return c;
}

- (NSString *)cache:(NSString *)filename
{
    return [[self cache] stringByAppendingPathComponent:filename];
}

- (NSString *)storage
{
    NSString *s = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSString *bid = [self bundleID];
    if (s != nil) {
        s = [[[s stringByAppendingPathComponent:@"Alfred 2"] stringByAppendingPathComponent:@"Workflow Data"] stringByAppendingPathComponent:bid];
    }
    [[NSFileManager defaultManager] createIfNonexistent:s];
    return s;
}

- (NSString *)storage:(NSString *)filename
{
    return [[self storage] stringByAppendingPathComponent:filename];
}





# pragma mark -
# pragma mark Feedback

- (void)flush:(BOOL)f feedbackItems:(id)fbi, ...
{
    va_list args;
    va_start(args, fbi);

    NSMutableString *o = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\"?><items>"];
    AWFeedbackItem *arg = fbi;
    do {
        [o appendString:[arg xml]];
    } while ((arg = va_arg(args, AWFeedbackItem *)));
    va_end(args);

    [o appendString:@"</items>"];
    printf("%s", [o UTF8String]);
    if (f) {
        printf("\n");
        exit(0);
    }
}

- (void)flush:(BOOL)f feedbackArray:(NSArray *)fba
{
    NSMutableString *o = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\"?><items>"];
    for (AWFeedbackItem *i in fba) {
        [o appendString:[i xml]];
    }
    [o appendString:@"</items>"];
    printf("%s", [o UTF8String]);
    if (f) {
        printf("\n");
        exit(0);
    }
}





# pragma mark -
# pragma mark Fuzzy search

- (NSArray *)fuzzySearchFor:(NSString *)query in:(NSArray *)array withKeyBlock:(NSString *(^)(id))key
{
    [array setFuzzy_delegate:self];
    return [array fuzzySearchFor:query withKeyBlock:key];
}







# pragma mark -
# pragma mark Argument parser

- (NSDictionary *)parseArguments:(const char *[])argv withKeys:(NSArray *)keys count:(int)argc
{
    AWArgs *awa = [[AWArgs alloc] initWithArgs:argv andKeys:keys count:argc];
    return [awa parse];
}








# pragma mark -
# pragma mark Preferences







# pragma mark -
# pragma mark AWFuzzySearchingDelegate methods

- (void)threwError:(NSString *)e
{
    [self log:e];
}

@end
