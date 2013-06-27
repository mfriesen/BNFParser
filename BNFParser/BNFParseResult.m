//
//  BNFParseResult.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFParseResult.h"

@implementation BNFParseResult

- (void)complete {
    
    if (!_success) {
        [self setError:_maxMatchToken];
    }
}

- (void)dealloc {
    [_maxMatchToken release];
    [_top release];
    [_error release];
    [super dealloc];
}

@end
