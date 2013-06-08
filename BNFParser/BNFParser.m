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

#import "BNFParser.h"
#import "BNFTokenizerFactory.h"

@implementation BNFParser

- (id)init {
    self = [super init];
    
    if (self) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [self setStates:dic];
        [dic release];
    }
    
    return self;
}

- (void)addState:(BNFState *)state {
    [_states setValue:state forKey:[state name]];
}

- (BNFState *)state:(NSString *)key {
    return [_states objectForKey:key];
}

- (BNFParserStatus *)parse:(NSString *)string {
    
    BNFTokenizerFactory *tokenizerFactory = [[BNFTokenizerFactory alloc] init];
    
    BNFTokenizer *tokenizer = [tokenizerFactory tokenizerWithString:string];
    BNFState *startState = [self state:@"@start"];
    BNFToken *topToken = [tokenizer top];
    
    BNFParserStatus *status = [[[BNFParserStatus alloc] initWithToken:topToken] autorelease];
  
    [startState parse:status states:_states];
    
    [tokenizerFactory release];
    
    return status;
}

- (void)dealloc {
    [_states release];
    [super dealloc];
}

@end
