//
//  BNFStateEmpty.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-22.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFStateEmpty.h"

@implementation BNFStateEmpty

- (BOOL)match:(BNFToken *)token {
    return FALSE;
}

@end
