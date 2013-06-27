//
//  BNFPath.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNFState.h"
#import "BNFToken.h"

@interface BNFPath : NSObject

@property (nonatomic, retain) BNFToken *token;

- (BNFState *)getNextState;

- (BOOL)isStateDefinition;
- (BOOL)isStateEnd;

@end
