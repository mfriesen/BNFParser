//
//  BNFStateDefinition.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNFState.h"

@interface BNFStateDefinition : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *states;

- (BOOL)hasSequences;

- (BNFState *)getFirstState;

@end
