//
//  BNFTokens.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-09-16.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNFToken.h"

@interface BNFTokens : NSObject

@property (nonatomic, assign) NSInteger pos;
@property (nonatomic, retain) NSMutableArray *tokens;

- (void)reset;
- (BNFToken *)nextToken;
- (void)addToken:(BNFToken *)token;

@end
