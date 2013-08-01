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

#import "BNFTokenizerFactory.h"
#import "Stack.h"
#import "BNFFastForward.h"

@implementation BNFTokenizerFactory

- (BNFToken *)tokens:(NSString *)text {
    BNFTokenizerParams *params = [[BNFTokenizerParams alloc] init];
    BNFToken *token = [self tokens:text params:params];
    [params release];
    return token;
}

- (BNFToken *)tokens:(NSString *)text2 params:(BNFTokenizerParams *)params {
    
    Stack *stack = [[Stack alloc] init];
    BNFFastForward *ff = [[BNFFastForward alloc] init];
    
    BNFTokenizerType lastType = BNFTokenizerType_NONE;
    
    NSString *text = [NSString stringWithCString:[text2 cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    
    if (!text) {
        text = text2;
    }
    
    NSInteger len = [text length];
    
    for (int i = 0; i < len; i++) {
        
        unichar c = [text characterAtIndex:i];
        BNFTokenizerType type = [self getType:c lastType:lastType];
        
        if ([ff isActive]) {
            
            [ff appendIfActiveChar:c];
            
            BOOL isFastForwardComplete = [ff isComplete:type lastType:lastType position:i length:len];
            
            if (isFastForwardComplete) {
                
                [self finishFastForward:stack fastForward:ff];
                [ff complete];
            }
            
        } else {
            
            [self calculateFastForward:ff type:type stack:stack lastType:lastType];
            
            if ([ff isActive]) {
                
                [ff appendIfActiveChar:c];
				
            } else if ([self includeText:type params:params]) {
                
                if ([self isAppendable:lastType current:type]) {
                    
                    BNFToken *token = [stack peek];
                    [token appendValue:c];
                    
                } else {
                    [self addBNFToken:stack type:type character:c];
                }
            }
        }
        
        lastType = type;
    }
    
    BNFToken *token;
    
    if (![stack isEmpty]) {
        token = [[[stack firstElement] retain] autorelease];
    } else {
        token = [[[BNFToken alloc] init] autorelease];
        [token setValueWithString:@""];
    }
    
    [ff release];
    [stack release];
    
    return token;
}

- (BOOL)includeText:(BNFTokenizerType) type params:(BNFTokenizerParams *)params {
    return ([params includeWhitespace] && type == BNFTokenizerType_WHITESPACE)
    || ([params includeWhitespaceOther] && type == BNFTokenizerType_WHITESPACE_OTHER)
    || ([params includeWhitespaceNewlines] && type == BNFTokenizerType_WHITESPACE_NEWLINE)
    || ![self isWhitespace:type];
}

- (void)calculateFastForward:(BNFFastForward *)ff type:(BNFTokenizerType)type stack:(Stack *)stack lastType:(BNFTokenizerType) lastType {
    
    BNFToken *last = ![stack isEmpty] ? [stack peek] : nil;
    [ff setStart:BNFTokenizerType_NONE];
    
    // single line comment
    if (lastType == BNFTokenizerType_SYMBOL_FORWARD_SLASH && type == BNFTokenizerType_SYMBOL_FORWARD_SLASH) {
        
        [ff setStart:BNFTokenizerType_COMMENT_SINGLE_LINE];
        [ff setEndWithType:BNFTokenizerType_WHITESPACE_NEWLINE];
        
        BNFToken *token = [stack pop];
        [ff appendIfActiveNSString:[token stringValue]];
        
		// multi line comment
    } else if (lastType == BNFTokenizerType_SYMBOL_FORWARD_SLASH && type == BNFTokenizerType_SYMBOL_STAR) {
        
        [ff setStart:BNFTokenizerType_COMMENT_MULTI_LINE];
        [ff setEndWithType:BNFTokenizerType_SYMBOL_FORWARD_SLASH type2:BNFTokenizerType_SYMBOL_STAR];
        
        BNFToken *token = [stack pop];
        [ff appendIfActiveNSString:[token stringValue]];
        
    } else if (type == BNFTokenizerType_QUOTE_DOUBLE) {
        
        [ff setStart:BNFTokenizerType_QUOTE_DOUBLE];
        [ff setEndWithType:BNFTokenizerType_QUOTE_DOUBLE];
		
    } else if (type == BNFTokenizerType_QUOTE_SINGLE && ![self isWord:last]) {
        
        [ff setStart:BNFTokenizerType_QUOTE_SINGLE];
        [ff setEndWithType:BNFTokenizerType_QUOTE_SINGLE];
    }
}

- (BOOL)isWord:(BNFToken *)last {
    return last && [last isWord];
}

- (void)finishFastForward:(Stack *)stack fastForward:(BNFFastForward *) ff {
    
    if ([self isComment:[ff start]]) {
        
        [self setNextToken:stack token:nil];
        
    } else {
        
        [self addBNFToken:stack type:[ff start] string:[ff getString]];
    }
}

- (void)addBNFToken:(Stack *)stack type:(BNFTokenizerType) type character:(unichar) c {
    [self addBNFToken:stack type:type string:[NSString stringWithFormat:@"%C",c]];
}

- (void)addBNFToken:(Stack *)stack type:(BNFTokenizerType)type string:(NSString *)s {
    
    BNFToken *token = [self createBNFToken:s type:type];
    
    if (![stack isEmpty]) {
        BNFToken *peek = [stack peek];
        [peek setNextToken:token];
        [token setIdentifier:[peek identifier] + 1];
    } else {
        [token setIdentifier:1];
    }
    
    [stack push:token];
}

- (void)setNextToken:(Stack *)stack token:(BNFToken *)nextToken {
    if (![stack isEmpty]) {
        [[stack peek]setNextToken:nextToken];
    }
}

- (BOOL)isAppendable:(BNFTokenizerType)lastType current:(BNFTokenizerType) current {
    return lastType == current && (current == BNFTokenizerType_LETTER || current == BNFTokenizerType_NUMBER);
}

- (BNFToken *)createBNFToken:(NSString *)value type:(BNFTokenizerType)type {
    BNFToken *token = [[[BNFToken alloc] init] autorelease];
    [token setValueWithString:value];
    
    if ([self isComment:type]) {
        [token setType:BNFTokenType_COMMENT];
    } else if ([self isNumber:type]) {
        [token setType:BNFTokenType_NUMBER];
    } else if ([self isLetter:type]) {
        [token setType:BNFTokenType_WORD];
    } else if ([self isSymbol:type]) {
        [token setType:BNFTokenType_SYMBOL];
    } else if (type == BNFTokenizerType_WHITESPACE_NEWLINE) {
        [token setType:BNFTokenType_WHITESPACE_NEWLINE];
    } else if ([self isWhitespace:type]) {
        [token setType:BNFTokenType_WHITESPACE];
    } else if ([self isQuote:type]) {
        [token setType:BNFTokenType_QUOTED_STRING];
    }
    
    return token;
}

- (BOOL)isQuote:(BNFTokenizerType)type {
    return type == BNFTokenizerType_QUOTE_DOUBLE || type == BNFTokenizerType_QUOTE_SINGLE;
}

- (BOOL)isSymbol:(BNFTokenizerType)type {
    return type == BNFTokenizerType_SYMBOL
    || type == BNFTokenizerType_SYMBOL_HASH
    || type == BNFTokenizerType_SYMBOL_AT
    || type == BNFTokenizerType_SYMBOL_STAR
    || type == BNFTokenizerType_SYMBOL_FORWARD_SLASH
    || type == BNFTokenizerType_SYMBOL_BACKWARD_SLASH;
}

- (BOOL)isWhitespace:(BNFTokenizerType)type {
    return type == BNFTokenizerType_WHITESPACE || type == BNFTokenizerType_WHITESPACE_OTHER || type == BNFTokenizerType_WHITESPACE_NEWLINE;
}

- (BOOL)isComment:(BNFTokenizerType) type {
    return type == BNFTokenizerType_COMMENT_MULTI_LINE
    || type == BNFTokenizerType_COMMENT_SINGLE_LINE;
}

- (BOOL)isNumber:(BNFTokenizerType)type {
    return type == BNFTokenizerType_NUMBER;
}

- (BOOL)isLetter:(BNFTokenizerType)type {
    return type == BNFTokenizerType_LETTER;
}

- (BNFTokenizerType)getType:(unichar)c lastType:(BNFTokenizerType)lastType {
    if (c == 10 || c == 13) {
        return BNFTokenizerType_WHITESPACE_NEWLINE;
    } else if (c >= 0 && c <= 31) { // From: 0 to: 31 From:0x00 to:0x20
        return BNFTokenizerType_WHITESPACE_OTHER;
    } else if (c == 32) {
        return BNFTokenizerType_WHITESPACE;
    } else if (c == 33) {
        return BNFTokenizerType_SYMBOL;
    } else if (c == '"') { // From: 34 to: 34 From:0x22 to:0x22
        return lastType == BNFTokenizerType_SYMBOL_BACKWARD_SLASH ? BNFTokenizerType_QUOTE_DOUBLE_ESCAPED : BNFTokenizerType_QUOTE_DOUBLE;
    } else if (c == '#') { // From: 35 to: 35 From:0x23 to:0x23
        return BNFTokenizerType_SYMBOL_HASH;
    } else if (c >= 36 && c <= 38) {
        return BNFTokenizerType_SYMBOL;
    } else if (c == '\'') { // From: 39 to: 39 From:0x27 to:0x27
        return lastType == BNFTokenizerType_SYMBOL_BACKWARD_SLASH ? BNFTokenizerType_QUOTE_SINGLE_ESCAPED : BNFTokenizerType_QUOTE_SINGLE;
    } else if (c >= 40 && c <= 41) {
        return BNFTokenizerType_SYMBOL;
    } else if (c == 42) {
        return BNFTokenizerType_SYMBOL_STAR;
    } else if (c == '+') { // From: 43 to: 43 From:0x2B to:0x2B
        return BNFTokenizerType_SYMBOL;
    } else if (c == 44) {
        return BNFTokenizerType_SYMBOL;
    } else if (c == '-') { // From: 45 to: 45 From:0x2D to:0x2D
        return BNFTokenizerType_NUMBER;
    } else if (c == '.') { // From: 46 to: 46 From:0x2E to:0x2E
        return BNFTokenizerType_NUMBER;
    } else if (c == '/') { // From: 47 to: 47 From:0x2F to:0x2F
        return BNFTokenizerType_SYMBOL_FORWARD_SLASH;
    } else if (c >= '0' && c <= '9') { // From: 48 to: 57 From:0x30 to:0x39
        return BNFTokenizerType_NUMBER;
    } else if (c >= 58 && c <= 63) {
        return BNFTokenizerType_SYMBOL;
    } else if (c == '@') { // From: 64 to: 64 From:0x40 to:0x40
        return BNFTokenizerType_SYMBOL_AT;
    } else if (c >= 'A' && c <= 'Z') { // From: 65 to: 90 From:0x41 to:0x5A
        return BNFTokenizerType_LETTER;
    } else if (c == 92) { // /
        return BNFTokenizerType_SYMBOL_BACKWARD_SLASH;
    } else if (c >= 91 && c <= 96) {
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 'a' && c <= 'z') { // From: 97 to:122 From:0x61 to:0x7A
        return BNFTokenizerType_LETTER;
    } else if (c >= 123 && c <= 191) {
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 0xC0 && c <= 0xFF) { // From:192 to:255 From:0xC0 to:0xFF
        return BNFTokenizerType_LETTER;
    } else if (c >= 0x19E0 && c <= 0x19FF) { // khmer symbols
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 0x2E00 && c <= 0x2E7F) { // supplemental punctuation
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 0x3000 && c <= 0x303F) { // cjk symbols & punctuation
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 0x3200 && c <= 0x33FF) { // enclosed cjk letters and months, cjk compatibility
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 0x4DC0 && c <= 0x4DFF) { // yijing hexagram symbols
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 0xFE30 && c <= 0xFE6F) { // cjk compatibility forms, small form variants
        return BNFTokenizerType_SYMBOL;
    } else if (c >= 0xFF00 && c <= 0xFFFF) { // hiragana & katakana halfwitdh & fullwidth forms, Specials
        return BNFTokenizerType_SYMBOL;
    } else {
        return BNFTokenizerType_LETTER;
    }
}

@end

