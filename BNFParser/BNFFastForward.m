//
//  BNFFastForward.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-24.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "BNFFastForward.h"

@implementation BNFFastForward

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        [self setEnd:list];
        [list release];
        
        [self setEndWithType:BNFTokenizerType_NONE];
        
        NSMutableString *s = [[NSMutableString alloc] init];
        [self setMs:s];
        [s release];
    }
    
    return self;
}

- (BOOL)isActive {
    return _start != BNFTokenizerType_NONE;
}

- (BOOL)isComplete:(BNFTokenizerType)type lastType:(BNFTokenizerType) lastType position:(NSInteger)i length:(NSInteger)len {
    return [self isMatch:type lastType:lastType] || (i == len - 1);
}

- (BOOL)isMatch:(BNFTokenizerType)type lastType:(BNFTokenizerType) lastType {
    
    BOOL match = NO;
    
    if ([_end count] == 1) {
        NSNumber *num = [_end objectAtIndex:0];
        match = type == [num integerValue];
    } else if ([_end count] == 2) {
        NSNumber *num0 = [_end objectAtIndex:0];
        NSNumber *num1 = [_end objectAtIndex:1];
        match = type == [num0 integerValue] && lastType == [num1 integerValue];
    }
    
    return match;
}

- (void)complete {
    _start = BNFTokenizerType_NONE;
    
    [self setEndWithType:BNFTokenizerType_NONE];

    [_ms setString:@""];
}

- (void)setEndWithType:(BNFTokenizerType)type {
    [_end removeAllObjects];
    [_end addObject:[NSNumber numberWithInt:type]];
}

- (void)setEndWithType:(BNFTokenizerType)type1 type2:(BNFTokenizerType)type2 {
    [_end removeAllObjects];
    [_end addObject:[NSNumber numberWithInt:type1]];
    [_end addObject:[NSNumber numberWithInt:type2]];
}

- (void)appendIfActiveChar:(char)c {
    if ([self isActive]) {
        [_ms appendFormat:@"%c", c];
    }
}

- (void)appendIfActiveNSString:(NSString *)s {
    if ([self isActive]) {
        [_ms appendString:s];
    }
}

- (NSString *)getString {
    NSString *immutableString = [NSString stringWithString:_ms];
    return immutableString;
}

- (void)dealloc {
    [_ms release];
    [_end release];
    [super dealloc];
}
@end
