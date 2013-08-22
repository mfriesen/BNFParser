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
#import "BNFSequence.h"
#import "BNFSymbol.h"

@interface BNFParserState : NSObject

typedef enum BNFParserRepetition : NSInteger {
    BNFParserRepetition_NONE,
    BNFParserRepetition_ZERO_OR_MORE,
    BNFParserRepetition_ZERO_OR_MORE_LOOKING_FOR_FIRST_MATCH
} BNFParserRepetition;

typedef enum ParserState : NSInteger {
    ParserState_NONE,
    ParserState_MATCH,
    ParserState_NO_MATCH_WITH_ZERO_REPETITION_LOOKING_FOR_FIRST_MATCH,
    ParserState_NO_MATCH,
    ParserState_MATCH_WITH_ZERO_REPETITION,
    ParserState_NO_MATCH_WITH_ZERO_REPETITION,
    ParserState_EMPTY
} ParserState;

@property (nonatomic, assign) NSInteger currentPosition;
@property (nonatomic, assign) ParserState state;
@property (nonatomic, retain) BNFToken *originalToken;
@property (nonatomic, retain) BNFToken *currentToken;
@property (nonatomic, retain) NSMutableArray *sequences;
@property (nonatomic, retain) BNFSequence *sequence;
@property (nonatomic, assign) BNFRepetition repetition;
@property (nonatomic, assign) BNFParserRepetition parserRepetition;

- (id)init;
- (id)initWithParserState:(ParserState)parserState;
- (id)initWithSequences:(NSMutableArray *)seqs token:(BNFToken *)token;
- (id)initWithToken:(BNFToken *)token;
- (id)initWithSequence:(BNFSequence *)seq token:(BNFToken *)token;
- (id)initWithSequences:(NSMutableArray *)sd token:(BNFToken *)token parserRepetition:(BNFParserRepetition)parserRep repetition:(BNFRepetition)rep;
- (id)initWithSequence:(BNFSequence *)seq token:(BNFToken *)token parserRepetition:(BNFParserRepetition)parserRep repetition:(BNFRepetition)rep;

- (void)advanceToken:(BNFToken *)token;
- (void)resetToken;
- (BOOL)isComplete;
- (void)reset;
- (BNFSequence *)nextSequence;
- (BNFSymbol *)nextSymbol;

@end
