//
//  BNFPath.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-23.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFPath.h"

@implementation BNFPath

- (BNFState *)getNextState {
    return nil;
}

- (BOOL)isStateDefinition {
    return NO;
}

- (BOOL)isStateEnd {
    return NO;
}

- (void)dealloc {
    [_token release];
    [super dealloc];
}

@end
