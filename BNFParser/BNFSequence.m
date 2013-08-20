//
//  BNFSequence.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-08-19.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFSequence.h"

@implementation BNFSequence

- (void)dealloc {
    [_symbols release];
    [super dealloc];
}
@end
