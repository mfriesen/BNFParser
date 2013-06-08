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

#import "BNFToken.h"

@implementation BNFToken

@synthesize position = _position;
@synthesize nextToken = _nextToken;
@synthesize isLastToken = _isLastToken;
@synthesize stringValue = _stringValue;

- (id)initWithToken:(PKToken *)token position:(NSInteger)position {
    
    self = [super init];
    
    if (self) {
        
        [self setPosition:position];
        PKToken *eof = [PKToken EOFToken];
        [self setIsLastToken:token == eof];
        [self setStringValue:[token stringValue]];
    }
    
    return self;
}

- (void)dealloc {
    [_stringValue release];
    [_nextToken release];
    [super dealloc];
}
@end
