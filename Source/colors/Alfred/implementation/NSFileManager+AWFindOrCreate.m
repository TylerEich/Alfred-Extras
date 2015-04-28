//
//  NSFileManager+AWFindOrCreate.m
//  alfred
//

#import "NSFileManager+AWFindOrCreate.h"

@implementation NSFileManager (AWFindOrCreate)

- (NSString *)findDirectory:(NSSearchPathDirectory)searchPathDirectory inDomain:(NSSearchPathDomainMask)domainMask appendingPathComponent:(NSString *)append
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory, domainMask, YES);
    if ([paths count] == 0) {
        return nil;
    }

    NSString *path = [paths objectAtIndex:0];
    if (append) {
        path = [path stringByAppendingPathComponent:append];
    }

    return path;
}

- (void)createIfNonexistent:(NSString *)dir
{
    NSError *creationError;
    [self createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&creationError];
}

- (NSString *)applicationSupportDirectory
{

    return [self findDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appendingPathComponent:nil];
}

- (NSString *)cacheDirectory
{
    return [self findDirectory:NSCachesDirectory inDomain:NSUserDomainMask appendingPathComponent:nil];
}

@end
