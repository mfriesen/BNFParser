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
    
    NSString *value = [token value];

    return ([value hasPrefix:@"\""] && [value hasSuffix:@"\""]) || ([value hasPrefix:@"'"] && [value hasSuffix:@"'"]);
}

@end
