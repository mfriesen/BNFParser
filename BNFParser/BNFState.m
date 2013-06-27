//
//  BNFState.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-22.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFState.h"

@implementation BNFState

- (id)init {
    self = [super init];
    
    if (self) {
        [self setRepetition:BNFRepetitionNONE];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    
    if (self) {
        [self setRepetition:BNFRepetitionNONE];
        [self setName:name];
    }
    
    return self;
}

- (BOOL)match:(BNFToken *)token {
    return [_name isEqualToString:[token value]];
}

- (BOOL)isEnd {
    return FALSE;
}

- (BOOL)isTerminal {
    return FALSE;
}

- (void)dealloc {
    [_name release];
    [_nextState release];

    [super dealloc];
}
@end
