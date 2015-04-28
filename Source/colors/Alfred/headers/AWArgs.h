//
//  AWArgs.h
//  Alfred
//
//  Created by Daniel Shannon on 5/26/13.
//  Copyright (c) 2013 Daniel Shannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWArgs : NSObject

- (id)initWithArgs:(const char *[])argv andKeys:(NSArray *)keys count:(int)argc;
- (NSDictionary *)parse;

@end
