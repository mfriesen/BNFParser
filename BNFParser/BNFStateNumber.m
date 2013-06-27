//
//  BNFStateNumber.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-22.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFStateNumber.h"

@implementation BNFStateNumber

- (BOOL)match:(BNFToken *)token {
    NSError *error = NULL;
    
    NSString *string = [token value];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\d\\-\\.]+$"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                  options:0
                                  range:NSMakeRange(0, [string length])];
    return numberOfMatches > 0;
}

@end
