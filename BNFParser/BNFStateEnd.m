//
//  BNFStateEnd.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-22.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFStateEnd.h"

@implementation BNFStateEnd

- (id)init {
    self = [super initWithName:@"@end"];    
    return self;
}

- (BOOL)isEnd {
    return TRUE;
}

@end
