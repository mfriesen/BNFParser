//
//  BNFSymbol.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-08-19.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFSymbol.h"

@implementation BNFSymbol

- (id)init {
    self = [super init];
    if (self) {
        [self setRepetition:BNFRepetition_NONE];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        [self setRepetition:BNFRepetition_NONE];
        [self setName:name];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name repetition:(BNFRepetition)repetition {
    self = [super init];
    if (self) {
        [self setRepetition:repetition];
        [self setName:name];
    }
    
    return self;
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}

@end
