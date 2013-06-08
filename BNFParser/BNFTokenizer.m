//
//  Copyright (c) 2013 Mike Friesen
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "BNFTokenizer.h"

@implementation BNFTokenizer

@synthesize top = _top;

- (id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        [self buildWithString:string];        
    }
    return self;
}

- (void)buildWithString:(NSString *)string {
    
    PKToken *tok = nil;
    BNFToken *lastToken = nil;
    NSInteger position = 0;

    PKToken *eof = [PKToken EOFToken];
    
    PKTokenizer *t = [PKTokenizer tokenizerWithString:string];
    
    while ((tok = [t nextToken]) != eof) {
        
        BNFToken *token = [[BNFToken alloc] initWithToken:tok position:position];
        
        if (lastToken) {
            [lastToken setNextToken:token];
        } else {
            [self setTop:token];
        }
        
        lastToken = token;
        [token release];
        
        position++;
    }
    
    BNFToken *token = [[BNFToken alloc] initWithToken:eof position:position];
    [lastToken setNextToken:token];
    [token release];
}

- (void)dealloc {
    [_top release];
    [super dealloc];
}

@end
