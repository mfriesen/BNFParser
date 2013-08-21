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

#import "BNFSymbol.h"

@implementation BNFSymbol

- (id)init {
    self = [super init];
    if (self) {
        [self setRepetition:BNFRepetition_NONE];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        [self setRepetition:BNFRepetition_NONE];
        [self setName:name];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name repetition:(BNFRepetition)repetition {
    self = [super init];
    if (self) {
        [self setRepetition:repetition];
        [self setName:name];
    }
    
    return self;
}

- (void)dealloc {
    [_name release];
    [super dealloc];
}

@end
