//
//  BNFPathState.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFPathState.h"
#import "BNFStateEnd.h"

@implementation BNFPathState

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithState:(BNFState *)state token:(BNFToken *)token {
    self = [super init];
    if (self) {
        [self setState:state];
        [self setToken:token];
    }
    return self;
}

- (BOOL)isStateEnd {
    return [_state isKindOfClass:[BNFStateEnd class]];
}

- (BNFState *)getNextState {
    return [_state nextState];
}

- (void)dealloc {
    [_state release];
    [super dealloc];
}
@end
