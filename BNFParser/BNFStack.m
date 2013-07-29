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

#import "BNFStack.h"
#import "BNFPath.h"
#import "BNFPathState.h"
#import "BNFPathStateDefinition.h"

@implementation BNFStack

/**
 * Rewinds to the next Token with next sequence
 */
- (void)rewindToNextTokenAndNextSequence {
    
    while (![self isEmpty]) {
        
        BNFPath *sp = [self peek];
        
        if ([sp isStateDefinition]) {
            
            BNFPathStateDefinition *spd = (BNFPathStateDefinition *) sp;
            
            if ([sp token] && [spd hasNextSequence]) {
                break;
            } else {
                [self pop];
            }
            
        } else {
            [self pop];
        }
    }
}

 - (BNFState *)rewindStackMatchedToken {
 
     BNFState *nextState = nil;
 
     while (![self isEmpty]) {
 
         BNFPath *sp = [self peek];
 
         if (![sp isStateDefinition]) {
 
             BNFPathState *bps = [self pop];
             BNFState *state = [bps state];
             nextState = [state nextState];
 
             if ([state repetition] != BNFRepetitionNONE) {
                 nextState = state;
             }
 
             if (nextState) {
                 break;
             }
 
         } else {
             [self pop];
         }
     }
 
     return nextState;
 }

/**
 * Rewinds stack to the next sequence, unless we find a repetition, then we'll find to the next state
 * @return BNFState - null or next state to put on stack
 */
 - (BNFState *)rewindStackUnmatchedToken {
 
     BNFState *nextState = nil;
     BOOL foundRepetition = NO;
 
     while (![self isEmpty]) {
 
         BNFPath *sp = [self peek];
 
         if (![sp isStateDefinition]) {
 
             BNFPathState *ps = (BNFPathState *) sp;
             BNFState *state = [ps state];
 
             if ([state repetition] != BNFRepetitionNONE) {
                 foundRepetition = YES;
             }
 
             [self pop];
 
             if (foundRepetition && [state nextState]) {
                 nextState = [state nextState];
                 break;
             }
 
         } else {
 
             BNFPathStateDefinition *spd = (BNFPathStateDefinition *)sp;
             if (foundRepetition) {
                 [self pop];
             } else if ([spd hasNextSequence]) {
                 break;
             } else {
                 [self pop];
             }
         }
     }
 
     return nextState;
 }
 
 - (BNFState *)rewindStackEmptyState {
 
    BNFState *nextState = nil;
 
    while (![self isEmpty]) {
 
        BNFPath *sp = [self peek];
 
        if ([sp isStateDefinition]) {
 
            BNFPathStateDefinition *sd = [self pop];
            nextState = [sd getNextState];
 
        } else {
 
            BNFPathState *bps = [self pop];
            nextState = [[bps state] nextState];
        }
 
        if (nextState) {
            break;
        }
    }
 
    return nextState;
}

@end
