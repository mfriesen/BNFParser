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

#import "BNFPathState.h"
#import "BNFStateEnd.h"

@implementation BNFPathState

- (id)init {
    self = [super init];
    return self;
}

- (id)initWithState:(BNFState *)state token:(BNFToken *)token {
    self = [super init];
    if (self) {
        [self setState:state];
        [self setToken:token];
    }
    return self;
}

- (BOOL)isStateEnd {
    return [_state isKindOfClass:[BNFStateEnd class]];
}

- (BNFState *)getNextState {
    return [_state nextState];
}

- (void)dealloc {
    [_state release];
    [super dealloc];
}
@end
