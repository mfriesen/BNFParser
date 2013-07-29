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

#import "BNFParser.h"
#import "BNFPath.h"
#import "BNFStateDefinition.h"
#import "BNFPathStateDefinition.h"
#import "BNFPathState.h"
#import "BNFStateEmpty.h"

@implementation BNFParser

- (id)initWithStateDefinitions:(NSMutableDictionary *)dic {
    self = [super init];
    if (self) {
        [self setStateDefinitions:dic];
        
        BNFStack *stack = [[BNFStack alloc] init];
        [self setStack:stack];
        [stack release];
    }
    
    return self;
}

- (BNFParseResult *)parse:(BNFToken *)token {
    
    [_stack clear];
 
    BNFParseResult *result = [[[BNFParseResult alloc] init] autorelease];
    [result setTop:token];
    [result setMaxMatchToken:token];
 
    BNFStateDefinition *sd = [_stateDefinitions objectForKey:@"@start"];
    [self pushToStackOrFirstState:token stateDefinition:sd];
 
    while (![_stack isEmpty]) {
 
        BNFPath *sp = [_stack peek];
 
        if ([sp isStateEnd]) {
 
            sp = [_stack pop];
 
            if ([self isEmpty:[sp token]]) {
                break;
            }
        
        } else if (![sp token]) {

            [_stack rewindToNextTokenAndNextSequence];

        } else if ([sp isStateDefinition]) {
 
            BOOL added = [self parseStateDefinition:[sp token]];
            if (!added) {
                break;
            }
 
        } else {
            [self parseState:result];
        }
    }
 
    [result complete];
 
    return result;
}
 
- (BOOL)isEmpty:(BNFToken *)token {
    return !token || !([token stringValue]) || [self stringLength:[token stringValue]] == 0;
}

- (NSInteger)stringLength:(NSString *)s {
    NSString *text = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [text length];
}

- (BOOL)parseStateDefinition:(BNFToken *)token {
    BOOL success = NO;
    BNFPathStateDefinition *sd = [_stack peek];
    BNFState *state = [sd getNextSequence];
    if (state) {
        success = YES;
        [self pushToStack:state token:token];
    }
 
    return success;
}

- (void)pushToStack:(BNFState *)state token:(BNFToken *)token {
 
    if (state) {
        BNFPathState *path = [[BNFPathState alloc] initWithState:state token:token];
        [_stack push:path];
        [path release];
    }
}

- (void)pushToStack:(BNFToken *)token stateDefinition:(BNFStateDefinition *)sd {
    
    BNFPathStateDefinition *path = [[[BNFPathStateDefinition alloc] init] autorelease];
    [path setToken:token];
    [path setStateDefinition:sd];
    [_stack push:path];
}


- (void)pushToStackOrFirstState:(BNFToken *)token stateDefinition:(BNFStateDefinition *)sd {
    
    if ([sd hasSequences]) {
        [self pushToStack:token stateDefinition:sd];
    } else {
        [self pushToStack:[sd getFirstState] token:token];
    }
}
 
- (void)parseState:(BNFParseResult *)result {
 
    BNFPathState *sp = [_stack peek];
    BNFState *state = [sp state];
    BNFToken *token = [sp token];
 
    if (![state isTerminal]) {
 
        BNFStateDefinition *sd = [_stateDefinitions objectForKey:[state name]];
 
        if (!sd) {
            [NSException raise:@"unknown state" format:@"unknown state %@", [state name]];
        }
 
        [self pushToStackOrFirstState:token stateDefinition:sd];
 
    } else if ([state isKindOfClass:[BNFStateEmpty class]]) {

        if ([self isEmpty:token]) {
            [result setSuccess:YES];
        }

        BNFState *rewindState = [_stack rewindStackEmptyState];
        [self pushToStack:rewindState token:token];
 
    } else if ([state match:token]) {
  
        [result setSuccess:YES];
        token = [token nextToken];
        
        if (token) {
            [result setMaxMatchToken:token];
        }
 
        BNFState *rewindState = [_stack rewindStackMatchedToken];
        [self pushToStack:rewindState token:token];
 
    } else {
 
        [result setSuccess:NO];
        BNFState *nextState = [_stack rewindStackUnmatchedToken];
        [self pushToStack:nextState token:token];
    }
}

@end
