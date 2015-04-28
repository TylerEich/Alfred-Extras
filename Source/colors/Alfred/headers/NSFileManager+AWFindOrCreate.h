//
//  NSFileManager+AWFindOrCreate.h
//  alfred
//

#import <Foundation/Foundation.h>

@interface NSFileManager (AWFindOrCreate)

- (NSString *)findDirectory:(NSSearchPathDirectory)searchPathDirectory inDomain:(NSSearchPathDomainMask)domainMask appendingPathComponent:(NSString *)append;
- (void)createIfNonexistent:(NSString *)dir;
- (NSString *)applicationSupportDirectory;
- (NSString *)cacheDirectory;

@end
