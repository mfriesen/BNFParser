//
//  BNFPathStateDefinition.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFPathStateDefinition.h"

@implementation BNFPathStateDefinition

- (BOOL)isStateDefinition {
    return YES;
}

- (BOOL)hasNextSequence {
    
    BNFState *state = nil;
    
    if (_position < [[_stateDefinition states] count]) {
        state = [[_stateDefinition states] objectAtIndex:_position];
    }
    
    return state != nil;
}

- (BNFState *)getNextSequence {
    
    BNFState *state = nil;
    
    if (_position < [[_stateDefinition states] count]) {
        state = [[_stateDefinition states] objectAtIndex:_position];
        _position++;
    }
    
    return state;
}

- (BNFState *)getNextState {
    
    BNFState *state = nil;
    
    if (_position < [[_stateDefinition states] count]) {
        state = [[[_stateDefinition states] objectAtIndex:_position] getNextState];
    }
    
    return state;
}

- (void)dealloc {
    [_stateDefinition release];
    [super dealloc];
}

@end
