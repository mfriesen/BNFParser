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

#import "BNFToken.h"

@implementation BNFToken

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
- (id)initWithValue:(NSString *)value {
    self = [super init];
    if (self) {
        [self setValueWithString:value];
    }
    return self;
}

- (void)appendValue:(unichar)ch {
    [_stringValue appendString:[NSString stringWithFormat:@"%C",ch]];
}

- (BOOL)isSymbol {
    return _type == BNFTokenType_SYMBOL;
}

- (BOOL)isWord {
    return _type == BNFTokenType_WORD;
}

- (BOOL)isQuotedString {
    return _type == BNFTokenType_QUOTED_STRING;
}

- (BOOL)isNumber {
    return _type == BNFTokenType_NUMBER;
}

- (BOOL)isComment {
    return _type == BNFTokenType_COMMENT;
}

- (BOOL)isWhitespace {
    return _type == BNFTokenType_WHITESPACE;
}

- (void)setValueWithString:(NSString *)value {
    NSMutableString *s = [[NSMutableString alloc] initWithString:value];
    [self setStringValue:s];
    [s release];
}

- (void)dealloc {
    [_stringValue release];
    [_nextToken release];
    [super dealloc];
}
@end
