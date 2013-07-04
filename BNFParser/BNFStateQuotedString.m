//
//  BNFStateQuotedString.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-22.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFStateQuotedString.h"

@implementation BNFStateQuotedString

- (BOOL)match:(BNFToken *)token {
    
    BOOL match = NO;
    
    if (token) {
        NSString *value = [token stringValue];

        match = ([value hasPrefix:@"\""] && [value hasSuffix:@"\""]) || ([value hasPrefix:@"'"] && [value hasSuffix:@"'"]);
    }
    
    return match;
}

@end
