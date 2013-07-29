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

#import <Foundation/Foundation.h>
#import "BNFToken.h"

@interface BNFState : NSObject

typedef enum BNFRepetition : NSInteger {
    BNFRepetitionNONE,
    BNFRepetitionZERO_OR_MORE
} BNFRepetition;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) BNFState *nextState;
@property (nonatomic, assign) BNFRepetition repetition;

- (id)init;
- (id)initWithName:(NSString *)name;

- (BOOL)match:(BNFToken *)token;
- (BOOL)isEnd;
- (BOOL)isTerminal;

@end
