//
//  BNFStateDefinition.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFStateDefinition.h"

@implementation BNFStateDefinition

- (BOOL)hasSequences {
    return [_states count] > 1;
}

- (BNFState *)getFirstState {
    
    BNFState *state = nil;
    
    if ([_states count] > 0) {
        state = [_states objectAtIndex:0];
    }
    
    return state;
}

- (void)dealloc {
    [_name release];
    [_states release];

    [super dealloc];
}

@end
