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

#import "BNFParserState.h"

@implementation BNFParserState

- (id)init {
    self = [super init];
    
    if (self) {
        [self setState:ParserState_NONE];
        [self setParserRepetition:BNFParserRepetition_NONE];
    }
    
    return self;
}

- (id)initWithParserState:(ParserState)parserState {
    self = [self init];
    
    if (self) {
        [self setState:parserState];
        [self setParserRepetition:BNFParserRepetition_NONE];
    }
    
    return self;
}

- (id)initWithSequences:(NSMutableArray *)seqs token:(BNFToken *)token {
    self = [self initWithToken:token];
    
    if (self) {
        [self setSequences:seqs];
    }
    
    return self;
}

- (id)initWithToken:(BNFToken *)token {
    self = [self init];
    
    if (self) {
        [self setOriginalToken:token];
        [self setCurrentToken:token];
    }
    
    return self;
}

- (id)initWithSequence:(BNFSequence *)seq token:(BNFToken *)token {
    self = [self initWithToken:token];
    
    if (self) {
        [self setSequence:seq];
    }
    
    return self;
}

- (id)initWithSequences:(NSMutableArray *)sd token:(BNFToken *)token parserRepetition:(BNFParserRepetition)parserRep repetition:(BNFRepetition)rep {
    self = [self initWithSequences:sd token:token];
    
    if (self) {
        [self setParserRepetition:parserRep];
        [self setRepetition:rep];
    }
    
    return self;
}

- (id)initWithSequence:(BNFSequence *)seq token:(BNFToken *)token parserRepetition:(BNFParserRepetition)parserRep repetition:(BNFRepetition)rep {
    self = [self initWithSequence:seq token:token];
    
    if (self) {
        [self setParserRepetition:parserRep];
        [self setRepetition:rep];
    }
    
    return self;
}

- (void)advanceToken:(BNFToken *)token {
    [self setCurrentToken:token];
}

- (void)resetToken {
    [self setCurrentToken:_originalToken];
}

- (BOOL)isSequences {
    return _sequences == NULL;
}

- (BOOL)isSequence {
    return _sequence == NULL;
}

- (BOOL)isComplete {
    return [self isCompleteSequence] || [self isCompleteSymbol];
}

- (BNFSequence *)getNextSequence {
    
    BNFSequence *seq = nil;
    NSInteger i = _currentPosition + 1;
    
    if (i < [_sequences count]) {
        seq = [_sequences objectAtIndex:i];
        [self setCurrentPosition:i];
    }
    
    return seq;
}

- (BOOL)isCompleteSequence {
    return _sequences && _currentPosition >= [_sequences count] - 1;
}

- (BNFSymbol *)getNextSymbol {
    
    BNFSymbol *symbol = nil;
    NSInteger i = _currentPosition + 1;
    
    if (i < [[_sequence symbols] count]) {
        symbol = [[_sequence symbols] objectAtIndex:i];
        [self setCurrentPosition:i];
    }
    
    return symbol;
}

- (BOOL)isCompleteSymbol {
    return _sequence && _currentPosition >= [[_sequence symbols] count] - 1;
}

- (void)reset {
    [self setCurrentPosition:-1];
}

@end
