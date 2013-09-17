//
//  BNFTokens.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-09-16.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFTokens.h"

@implementation BNFTokens

- (id)init {
    
    self = [super init];
    if (self) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [self setTokens:list];
        [list release];
        
        [self reset];
    }
    
    return self;
}

- (void)reset {
    [self setPos:0];
}

- (void)addToken:(BNFToken *)token {
    [_tokens addObject:token];
}

- (BNFToken *)nextToken {
    BNFToken *tok = nil;
    
    if (_pos < [_tokens count]) {
        tok = [_tokens objectAtIndex:_pos];
        [self setPos:_pos + 1];
    }
    
    return tok;
}


- (void)dealloc {
    [_tokens release];
    [super dealloc];
}

@end
