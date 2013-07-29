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

#import "BNFStateDefinition.h"

@implementation BNFStateDefinition

- (BOOL)hasSequences {
    return [_states count] > 1;
}

- (BNFState *)getFirstState {
    
    BNFState *state = nil;
    
    if ([_states count] > 0) {
        state = [_states objectAtIndex:0];
    }
    
    return state;
}

- (void)dealloc {
    [_name release];
    [_states release];

    [super dealloc];
}

@end
