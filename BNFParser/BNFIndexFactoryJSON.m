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

#import "BNFIndexFactoryJSON.h"
#import "BNFIndexNode.h"
#import "BNFToken.h"
#import "Stack.h"
#import "BNFIndex.h"
#import "BNFParseResult.h"

@implementation BNFIndexFactoryJSON

- (BNFIndex *)createIndex:(BNFParseResult *)result {
    return [self createIndex:result operation:nil];
}

- (BNFIndex *)createIndex:(BNFParseResult *)result operation:(NSBlockOperation *)operation {

    BOOL cancelled = NO;
    
    if (![result success]) {
        return nil;
    }
    
    Stack *stack = [[Stack alloc] init];
    
    BNFIndex *index = [[BNFIndex alloc] init];
    
    NSString *keyValue = nil;
    BNFToken *token = [result top];
    
    while (token) {
        
        if ([self isStartNode:token]) {
            
            BNFIndexNode *node = [self createIndexNode:token keyValue:keyValue];
            
            if (!keyValue) {
                [node setShouldSkip:YES];
            }
            
            [self addNode:stack index:index node:node];
            
            [stack push:node];
            keyValue = nil;
            
        } else if ([self isKey:token]) {
            
            keyValue = [self stringValue:token];
            
        } else if ([self isEndNode:token]) {
            
            [stack pop];
            
            BNFIndexNode *node = [self createIndexNode:token keyValue:keyValue];
            [self addNode:stack index:index node:node];
            
        } else if ([self isValue:token]) {
            
            BNFIndexNode *node = [[BNFIndexNode alloc] initWithKeyValue:keyValue stringValue:[self stringValue:token]];
            [self addNode:stack index:index node:node];
            [node release];
            
            keyValue = nil;
        }
        
        token = [self nextToken:token];
        
        if ([operation isCancelled]) {
            cancelled = YES;
            break;
        }
    }
    
    [stack release];
    
    if (cancelled) {
        [index release];
        return nil;
    }
    
    return [index autorelease];
}

/**
 * Create an IndexNode.
 * @param token -
 * @param keyValue -
 * @return BNFIndexNode
 */
- (BNFIndexNode *)createIndexNode:(BNFToken *)token keyValue:(NSString *)keyValue {
    
    BNFIndexNode *node = nil;
    
    if (keyValue) {
        node = [[BNFIndexNode alloc] initWithKeyValue:keyValue stringValue:[self stringValue:token]];
    } else {
        node = [[BNFIndexNode alloc] initWithKeyValue:[self stringValue:token] stringValue:nil];
    }
    
    return [node autorelease];
}

/**
 * Add Node to Index.
 * @param stack -
 * @param index -
 * @param node -
 */
- (void)addNode:(Stack *)stack index:(BNFIndex *)index node:(BNFIndexNode *)node {
    if ([stack isEmpty]) {
        [index addNode:node];
    } else {
        [[stack peek] addNode:node];
    }
}

/**
 * Gets the String value for the token if String is QuotedString, removes quotes.
 * @param token -
 * @return String
 */
- (NSString *)stringValue:(BNFToken *)token {
    
    NSString *value = [token stringValue];
    return value;
}

/**
 * Returns with token is a start token.
 * @param token -
 * @return boolean
 */
- (BOOL)isStartNode:(BNFToken *)token {
    NSString *value = [token stringValue];
    return [value isEqualToString:@"{"] || [value isEqualToString:@"["];
}

/**
 * Returns with token is a end token.
 * @param token -
 * @return boolean
 */
- (BOOL)isEndNode:(BNFToken *)token {
    NSString *value = [token stringValue];
    return [value isEqualToString:@"}"] || [value isEqualToString:@"]"];
}

/**
 * Returns with token is a key token.
 * @param token -
 * @return boolean
 */
- (BOOL)isKey:(BNFToken *)token {
    
    BOOL key = NO;
    NSString *value = [token stringValue];
    
    if (value && [token nextToken]) {
        BNFToken *nextToken = [token nextToken];
        key = [@":" isEqualToString:[nextToken stringValue]];
    }
    
    return key;
}

/**
 * Returns with token is a value token.
 * @param token -
 * @return boolean
 */
- (BOOL)isValue:(BNFToken *)token {
    NSString *value = [token stringValue];
    return ![value isEqualToString:@":"] && ![value isEqualToString:@","];
}

/**
 * Returns the next token.
 * @param token -
 * @return BNFToken
 */
- (BNFToken *)nextToken:(BNFToken *)token {
    
    BNFToken *nextToken = [token nextToken];
    return nextToken;
}

@end
