//
//  BNFStack.h
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stack.h"
#import "BNFState.h"

@interface BNFStack : Stack

- (void)rewindToNextTokenAndNextSequence;
- (BNFState *)rewindStackMatchedToken;
- (BNFState *)rewindStackUnmatchedToken;
- (BNFState *)rewindStackEmptyState;

@end
