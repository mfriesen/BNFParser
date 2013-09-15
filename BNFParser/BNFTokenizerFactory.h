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

#import <Foundation/Foundation.h>
#import "BNFToken.h"
#import "BNFTokenizerParams.h"

@interface BNFTokenizerFactory : NSObject

typedef enum BNFTokenizerType : NSInteger {
    BNFTokenizerType_NONE,
    BNFTokenizerType_COMMENT_SINGLE_LINE,
    BNFTokenizerType_COMMENT_MULTI_LINE,
    BNFTokenizerType_QUOTE_SINGLE,
    BNFTokenizerType_QUOTE_SINGLE_ESCAPED,
    BNFTokenizerType_QUOTE_DOUBLE,
    BNFTokenizerType_QUOTE_DOUBLE_ESCAPED,
    BNFTokenizerType_NUMBER,
    BNFTokenizerType_LETTER,
    BNFTokenizerType_SYMBOL,
    BNFTokenizerType_SYMBOL_HASH,
    BNFTokenizerType_SYMBOL_AT,
    BNFTokenizerType_SYMBOL_STAR,
    BNFTokenizerType_SYMBOL_FORWARD_SLASH,
    BNFTokenizerType_SYMBOL_BACKWARD_SLASH,
    BNFTokenizerType_WHITESPACE,
    BNFTokenizerType_WHITESPACE_OTHER,
    BNFTokenizerType_WHITESPACE_NEWLINE
} BNFTokenizerType;

- (BNFToken *)tokens:(NSString *)text;
- (BNFToken *)tokens:(NSString *)text operation:(NSBlockOperation *)operation;

- (BNFToken *)tokens:(NSString *)text params:(BNFTokenizerParams *)params;
- (BNFToken *)tokens:(NSString *)text params:(BNFTokenizerParams *)params operation:(NSBlockOperation *)operation;
@end

