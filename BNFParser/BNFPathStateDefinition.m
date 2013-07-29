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

#import "BNFPathStateDefinition.h"

@implementation BNFPathStateDefinition

- (BOOL)isStateDefinition {
    return YES;
}

- (BOOL)hasNextSequence {
    
    BNFState *state = nil;
    
    if (_position < [[_stateDefinition states] count]) {
        state = [[_stateDefinition states] objectAtIndex:_position];
    }
    
    return state != nil;
}

- (BNFState *)getNextSequence {
    
    BNFState *state = nil;
    
    if (_position < [[_stateDefinition states] count]) {
        state = [[_stateDefinition states] objectAtIndex:_position];
        _position++;
    }
    
    return state;
}

- (BNFState *)getNextState {
    
    BNFState *state = nil;
    
    if (_position < [[_stateDefinition states] count]) {
        state = [[[_stateDefinition states] objectAtIndex:_position] getNextState];
    }
    
    return state;
}

- (void)dealloc {
    [_stateDefinition release];
    [super dealloc];
}

@end
