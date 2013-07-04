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
    BOOL match = NO;
    
    if (token) {
        NSError *error = NULL;
        
        NSString *string = [token stringValue];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[\\d\\-\\.]+$"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                      options:0
                                      range:NSMakeRange(0, [string length])];
        match = numberOfMatches > 0;
    }
    
    return match;
}

@end
