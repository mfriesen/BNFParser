//
// Copyright 2013 Mike Friesen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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