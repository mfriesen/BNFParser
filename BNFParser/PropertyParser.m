//
//  PropertyParser.m
//  BNFParser
//
//  Created by Mike Friesen on 2013-06-24.
//  Copyright (c) 2013 Mike Friesen. All rights reserved.
//

#import "PropertyParser.h"
#import "BNFTokenizerFactory.h"
#import "BNFTokenizerParams.h"

@implementation PropertyParser

- (NSMutableDictionary *)parse:(NSString *)s {
   
    BNFTokenizerFactory *tokenizer = [[BNFTokenizerFactory alloc] init];
    
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    
    BNFTokenizerParams *params = [[BNFTokenizerParams alloc] init];
    [params setIncludeWhitespace:YES];
    [params setIncludeWhitespaceNewlines:YES];
    
    BNFToken *token = [tokenizer tokens:s params:params];
    
    NSString *start = @"";
    NSMutableString *sb = [[NSMutableString alloc] init];
    
    while (token) {
		
        if ([token type] == BNFTokenType_WHITESPACE_NEWLINE) {
            
            [self addValue:dic sb:sb start:start];
            
            start = @"";
            [sb setString:@""];
            
        } else if ([[token stringValue] isEqualToString:@"="]) {
            
            start = [NSString stringWithString:sb];
            [sb setString:@""];
            
        } else {
            
            [sb appendString:[token stringValue]];
        }
        
        token = [token nextToken];
    }
    
    [self addValue:dic sb:sb start:start];
    
    [sb release];
    [tokenizer release];
    [params release];
    
    return dic;
}

- (void)addValue:(NSMutableDictionary *)dic sb:(NSMutableString *)sb start:(NSString *)start {
    if ([self hasText:start] && [self hasText:sb]) {
        
        NSString *key = [start stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *value = [[NSString stringWithString:sb] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [dic setValue:value forKey:key];
    }
}

- (BOOL)hasText:(NSString *)s {
    return s && [s length] > 0;
}

@end